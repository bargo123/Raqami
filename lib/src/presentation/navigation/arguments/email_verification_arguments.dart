import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_arguments.freezed.dart';

@freezed
sealed class EmailVerificationArguments with _$EmailVerificationArguments {
  const factory EmailVerificationArguments({
    String? email,
  }) = _EmailVerificationArguments;

  factory EmailVerificationArguments.fromMap(Map<String, dynamic> map) {
    return EmailVerificationArguments(
      email: map['email'] as String?
      );
  }
}

