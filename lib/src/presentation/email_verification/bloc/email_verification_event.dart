part of 'email_verification_bloc.dart';

@freezed
class EmailVerificationEvent with _$EmailVerificationEvent {
  const factory EmailVerificationEvent.started({
    String? email,
  }) = _Started;
  const factory EmailVerificationEvent.otpCodeChanged(String otpCode) = _OtpCodeChanged;
  const factory EmailVerificationEvent.verifyOtp() = _VerifyOtp;
  const factory EmailVerificationEvent.resendOtp() = _ResendOtp;
}



