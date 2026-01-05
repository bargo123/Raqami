import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/use_case/sign_up_with_email_use_case.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';
part 'create_account_bloc.freezed.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc({required SignUpWithEmailUseCase signUpWithEmailUseCase})
      : _signUpWithEmailUseCase = signUpWithEmailUseCase,
        super(CreateAccountState.initial()) {
    on<_PhoneNumberChanged>(_onPhoneNumberChanged);
    on<_NameChanged>(_onNameChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_TermsAcceptedChanged>(_onTermsAcceptedChanged);
    on<_CreateAccount>(_onCreateAccount);
    on<_EmptyErrors>(_onEmptyErrors);
  }

  final SignUpWithEmailUseCase _signUpWithEmailUseCase;



  void _onPhoneNumberChanged(
    _PhoneNumberChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(state.copyWith(
      phoneNumber: event.phoneNumber,
      phoneNumberError: null, // Clear error when user types
    ));
  }

  void _onNameChanged(
    _NameChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
      nameError: null, // Clear error when user types
    ));
  }

  void _onEmailChanged(
    _EmailChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      emailError: null, // Clear error when user types
    ));
  }

  void _onPasswordChanged(
    _PasswordChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      passwordError: null, // Clear error when user types
    ));
  }

  void _onTermsAcceptedChanged(
    _TermsAcceptedChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(state.copyWith(
      termsAccepted: event.accepted,
      termsError: null, // Clear error when user changes checkbox
    ));
  }

  Future<void> _onCreateAccount(
    _CreateAccount event,
    Emitter<CreateAccountState> emit,
  ) async {
    // Clear previous errors
    emit(state.copyWith(
      isLoading: true,
      phoneNumberError: null,
      nameError: null,
      emailError: null,
      passwordError: null,
      termsError: null,
      generalError: null,
    ));

    // Validate fields - set field-level errors
    bool hasFieldErrors = false;
    String? phoneError;
    String? nameError;
    String? emailError;
    String? passwordError;
    String? termsError;

    if (state.phoneNumber.isEmpty) {
      phoneError = 'phoneNumberIsRequired';
      hasFieldErrors = true;
    }

    if (state.name.isEmpty) {
      nameError = 'nameIsRequired';
      hasFieldErrors = true;
    }

    if (state.email.isEmpty) {
      emailError = 'emailIsRequired';
      hasFieldErrors = true;
    } else if (!_isValidEmail(state.email)) {
      emailError = 'pleaseEnterAValidEmailAddress';
      hasFieldErrors = true;
    }

    if (state.password.isEmpty) {
      passwordError = 'passwordIsRequired';
      hasFieldErrors = true;
    } else if (state.password.length < 6) {
      passwordError = 'passwordMustBeAtLeast6Characters';
      hasFieldErrors = true;
    }

    if (!state.termsAccepted) {
      termsError = 'pleaseAcceptTheTermsAndPrivacyPolicy';
      hasFieldErrors = true;
    }

    if (hasFieldErrors) {
      emit(state.copyWith(
        isLoading: false,
        phoneNumberError: phoneError,
        nameError: nameError,
        emailError: emailError,
        passwordError: passwordError,
        termsError: termsError,
      ));
      return;
    }

    try {
      // Sign up with email and password (sends verification email)
      await _signUpWithEmailUseCase(
        email: state.email,
        password: state.password,
        name: state.name,
        phoneNumber: state.phoneNumber,
      );

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));
    } on FirebaseAuthException catch (e) {
      print(e);
      // Handle Firebase Auth errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'anAccountWithThisEmailAlreadyExists';
          break;
        case 'invalid-email':
          errorMessage = 'invalidEmailAddress';
          break;
        case 'weak-password':
          errorMessage = 'passwordIsTooWeak';
          break;
        case 'network-request-failed':
          errorMessage = 'networkErrorPleaseCheckYourConnection';
          break;
        case 'email-not-verified':
          errorMessage = 'emailNotVerifiedPleaseCheckYourEmailAndClickTheVerificationLink';
          break;
        default:
          errorMessage = 'accountCreationFailedPleaseTryAgain';
      }
      emit(state.copyWith(
        isLoading: false,
        generalError: errorMessage,
      ));
    } catch (e) {
      // Handle other errors
      emit(state.copyWith(
        isLoading: false,
        generalError: 'somethingUnexpectedHappenedPleaseTryAgain',
      ));
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _onEmptyErrors(
    _EmptyErrors event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(state.copyWith(
      generalError: null,
      isSuccess: false,
    ));
  }
}

