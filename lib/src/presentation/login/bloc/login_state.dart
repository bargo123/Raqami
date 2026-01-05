part of 'login_bloc.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(true) bool isEmailVerified,
    String? emailError,
    String? passwordError,
    String? generalError, // For network errors, server errors, etc.
  }) = _LoginState;

  factory LoginState.initial() => const LoginState();
}
