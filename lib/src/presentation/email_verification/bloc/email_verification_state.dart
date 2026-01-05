part of 'email_verification_bloc.dart';

@freezed
sealed class EmailVerificationState with _$EmailVerificationState {
  const factory EmailVerificationState({
    @Default('') String otpCode,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? email,
    String? generalError, // For network errors, server errors, etc.
  }) = _EmailVerificationState;

  factory EmailVerificationState.initial() => const EmailVerificationState();
}



