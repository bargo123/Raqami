import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/use_case/sign_in_with_email_use_case.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required SignInWithEmailUseCase signInWithEmailUseCase})
      : _signInWithEmailUseCase = signInWithEmailUseCase,
        super(LoginState.initial()) {
    on<_Started>(_onStarted);
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_Login>(_onLogin);
    on<_ClearGeneralError>(_onClearGeneralError);
  }

  final SignInWithEmailUseCase _signInWithEmailUseCase;

  void _onStarted(_Started event, Emitter<LoginState> emit) {
    emit(LoginState.initial());
  }

  void _onEmailChanged(
    _EmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      emailError: null, // Clear error when user types
      generalError: null, // Clear general error when user types
    ));
  }

  void _onPasswordChanged(
    _PasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      passwordError: null, // Clear error when user types
      generalError: null, // Clear general error when user types
    ));
  }

  void _onClearGeneralError(
    _ClearGeneralError event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      generalError: null,
      isSuccess: false,
    ));
  }

  Future<void> _onLogin(
    _Login event,
    Emitter<LoginState> emit,
  ) async {
    // Clear previous errors
    emit(state.copyWith(
      isLoading: true,
      emailError: null,
      passwordError: null,
      generalError: null,
    ));

    // Validate fields - set field-level errors
    bool hasFieldErrors = false;
    String? emailError;
    String? passwordError;

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

    if (hasFieldErrors) {
      emit(state.copyWith(
        isLoading: false,
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    try {
      // Sign in with email and password
     var isEmailVerified = await _signInWithEmailUseCase(state.email, state.password);
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        isEmailVerified: isEmailVerified??false,
      ));

    } on FirebaseAuthException catch (e) {
      print(e);
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'noAccountFoundWithThisEmail';
          break;
        case 'wrong-password':
          errorMessage = 'incorrectPassword';
          break;
        case 'invalid-email':
          errorMessage = 'invalidEmailAddress';
          break;
        case 'user-disabled':
          errorMessage = 'thisAccountHasBeenDisabled';
          break;
        case 'too-many-requests':
          errorMessage = 'tooManyFailedAttemptsPleaseTryAgainLater';
          break;
        case 'network-request-failed':
          errorMessage = 'networkErrorPleaseCheckYourConnection';
          break;
        default:
          errorMessage = 'loginFailedPleaseTryAgain';
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
}
