import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/use_case/update_user_profile_use_case.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_bloc.freezed.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  }) :
        _updateUserProfileUseCase = updateUserProfileUseCase,
        super(EditProfileState.initial()) {
    on<_Started>(_onStarted);
    on<_FullNameChanged>(_onFullNameChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_PhoneNumberChanged>(_onPhoneNumberChanged);
    on<_UpdateProfile>(_onUpdateProfile);
  }

  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  void _onStarted(
    _Started event,
    Emitter<EditProfileState> emit,
  ) {   
        add(EditProfileEvent.fullNameChanged(event.fullName ?? ''));
        add(EditProfileEvent.emailChanged(event.email ?? ''));
        add(EditProfileEvent.phoneNumberChanged(event.phoneNumber ?? ''));
      
  
  }

  void _onFullNameChanged(
    _FullNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(
      fullName: event.fullName,
      fullNameError: null,
    ));
  }

  void _onEmailChanged(
    _EmailChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _onPhoneNumberChanged(
    _PhoneNumberChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(
      phoneNumber: event.phoneNumber,
      phoneNumberError: null,
    ));
  }

  

  Future<void> _onUpdateProfile(
    _UpdateProfile event,
    Emitter<EditProfileState> emit,
  ) async {
    // Clear previous errors
    emit(state.copyWith(
      isLoading: true,
      fullNameError: null,
      phoneNumberError: null,
      error: null,
    ));

    // Validate fields
    String? fullNameError;
    String? phoneNumberError;
    bool hasFieldErrors = false;

    // Validate Full Name
    if (state.fullName.trim().isEmpty) {
      fullNameError = 'fullNameIsRequired';
      hasFieldErrors = true;
    }


    // Validate Phone Number
    if (state.phoneNumber.trim().isEmpty) {
      phoneNumberError = 'phoneNumberIsRequired';
      hasFieldErrors = true;
    }

    if (hasFieldErrors) {
      emit(state.copyWith(
        fullNameError: fullNameError,
        phoneNumberError: phoneNumberError,
        isLoading: false,
      ));
      return;
    }

    try {
      await _updateUserProfileUseCase(
        name: state.fullName.trim(),
        email: state.email.trim(),
        phoneNumber: state.phoneNumber.trim(),
      );

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      ));
    }
  }

}

