import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/line_type.dart';
import 'package:raqami/src/domain/use_case/create_post_use_case.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';
part 'create_post_bloc.freezed.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc({
    required CreatePostUseCase createPostUseCase,
  })  : _createPostUseCase = createPostUseCase,
        super(CreatePostState.initial()) {
    on<_Started>(_onStarted);
    on<_PostTypeChanged>(_onPostTypeChanged);
    on<_NumberChanged>(_onNumberChanged);
    on<_PlateCodeChanged>(_onPlateCodeChanged);
    on<_PhoneCodeChanged>(_onPhoneCodeChanged);
    on<_PhoneProviderChanged>(_onPhoneProviderChanged);
    on<_LineTypeChanged>(_onLineTypeChanged);
    on<_PriceChanged>(_onPriceChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_EmirateChanged>(_onEmirateChanged);
    on<_PlateTypeChanged>(_onPlateTypeChanged);
    on<_CreatePost>(_onCreatePost);
    on<_ClearErrors>(_onClearErrors);
  }

  final CreatePostUseCase _createPostUseCase;

  void _onStarted(_Started event, Emitter<CreatePostState> emit) {
    emit(CreatePostState.initial());
  }

  void _onPostTypeChanged(
    _PostTypeChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      postType: event.type,
      number: '', // Clear number when switching post types
      emirate: event.type == PostType.carPlate ? state.emirate : null,
      plateType: event.type == PostType.carPlate ? state.plateType : null,
      plateCode: event.type == PostType.carPlate ? state.plateCode : '',
      phoneCode: event.type == PostType.phoneNumber ? state.phoneCode : '',
      numberError: null,
      emirateError: null,
    ));
  }

  void _onNumberChanged(
    _NumberChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      number: event.number,
      numberError: null,
    ));
  }

  void _onPlateCodeChanged(
    _PlateCodeChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      plateCode: event.code,
      plateCodeError: null,
    ));
  }

  void _onPhoneCodeChanged(
    _PhoneCodeChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      phoneCode: event.code,
      phoneCodeError: null,
    ));
  }

  void _onPhoneProviderChanged(
    _PhoneProviderChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      phoneProvider: event.provider,
    ));
  }

  void _onLineTypeChanged(
    _LineTypeChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      lineType: event.lineType,
    ));
  }

  void _onPriceChanged(
    _PriceChanged event,
    Emitter<CreatePostState> emit,
  ) {
    // Update the appropriate price field based on current post type
    if (state.postType == PostType.phoneNumber) {
      emit(state.copyWith(
        phonePrice: event.price,
        priceError: null,
      ));
    } else {
      emit(state.copyWith(
        platePrice: event.price,
        priceError: null,
      ));
    }
  }

  void _onDescriptionChanged(
    _DescriptionChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onEmirateChanged(
    _EmirateChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      emirate: event.emirate,
      emirateError: null,
    ));
  }

  void _onPlateTypeChanged(
    _PlateTypeChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      plateType: event.plateType,
      plateCode: '', // Clear code when plate type changes
      plateCodeError: null,
    ));
  }

  void _onClearErrors(
    _ClearErrors event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(
      numberError: null,
      plateCodeError: null,
      priceError: null,
      emirateError: null,
      generalError: null,
    ));
  }

  Future<void> _onCreatePost(
    _CreatePost event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      numberError: null,
      plateCodeError: null,
      priceError: null,
      emirateError: null,
      generalError: null,
    ));

    // Validation
    bool hasErrors = false;
    String? numberError;
    String? plateCodeError;
    String? priceError;
    String? emirateError;

    // Validate phone code for phone numbers
    if (state.postType == PostType.phoneNumber) {
      if (state.phoneCode.trim().isEmpty) {
        numberError = 'phoneCodeIsRequired';
        hasErrors = true;
      }
    }

    // Validate number
    if (state.number.trim().isEmpty) {
      numberError = state.postType == PostType.phoneNumber
          ? 'phoneNumberIsRequired'
          : 'plateNumberIsRequired';
      hasErrors = true;
    } else if (state.postType == PostType.phoneNumber) {
      // Validate phone number format - must be exactly 7 digits
      final phoneRegex = RegExp(r'^[0-9]{7}$');
      if (!phoneRegex.hasMatch(state.number.trim())) {
        numberError = 'phoneNumberMustBe7Digits';
        hasErrors = true;
      }
    } else if (state.postType == PostType.carPlate) {
      // Validate plate number format - must be 1 to 5 digits
      final plateRegex = RegExp(r'^[0-9]{1,5}$');
      if (!plateRegex.hasMatch(state.number.trim())) {
        numberError = 'invalidPlateFormat';
        hasErrors = true;
      }
    }

    // Validate plate code for car plates
    if (state.postType == PostType.carPlate && state.emirate != null) {
      final plateType = state.plateType == 'Classic' 
          ? PlateType.classic 
          : PlateType.standard;
      final plateSelection = PlateSelection(
        emirate: state.emirate!,
        plateType: plateType,
      );
      
      if (plateSelection.requiresCode) {
        final code = state.plateCode.trim().toUpperCase();
        if (code.isEmpty) {
          plateCodeError = 'plateCodeIsRequired';
          hasErrors = true;
        } else if (!plateSelection.isValidCode(code)) {
          plateCodeError = 'invalidPlateCode';
          hasErrors = true;
        }
      }
    }

    // Validate price based on post type
    final currentPrice = state.postType == PostType.phoneNumber 
        ? state.phonePrice 
        : state.platePrice;
    if (currentPrice.trim().isEmpty) {
      priceError = 'priceIsRequired';
      hasErrors = true;
    } else {
      final priceValue = double.tryParse(currentPrice.trim());
      if (priceValue == null || priceValue <= 0) {
        priceError = 'invalidPrice';
        hasErrors = true;
      }
    }

    // Validate emirate for car plates
    if (state.postType == PostType.carPlate && state.emirate == null) {
      emirateError = 'emirateIsRequired';
      hasErrors = true;
    }

    if (hasErrors) {
      emit(state.copyWith(
        isLoading: false,
        numberError: numberError,
        plateCodeError: plateCodeError,
        priceError: priceError,
        emirateError: emirateError,
      ));
      return;
    }

    try {
      // Get the appropriate price based on post type
      final currentPrice = state.postType == PostType.phoneNumber 
          ? state.phonePrice 
          : state.platePrice;
      
      // Combine phone code and number for phone numbers
      final fullNumber = state.postType == PostType.phoneNumber
          ? '${state.phoneCode.trim()} ${state.number.trim()}'
          : state.number.trim();
      
      // Create the post (defaulting to UAE for now)
      await _createPostUseCase(
        countryCode: FirestoreConstants.countryCodeUAE,
        type: state.postType,
        number: fullNumber,
        price: double.parse(currentPrice.trim()),
        currency: 'AED',
        description: state.description.trim().isEmpty ? null : state.description.trim(),
        emirate: state.emirate,
        plateType: state.plateType,
        plateCode: state.plateCode.trim().isEmpty ? null : state.plateCode.trim(),
        phoneProvider: state.postType == PostType.phoneNumber ? state.phoneProvider : null,
        lineType: state.postType == PostType.phoneNumber ? state.lineType : null,
      );
      
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        generalError: 'somethingUnexpectedHappenedPleaseTryAgain',
      ));
    }
  }
}

