import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_arguments.freezed.dart';

@freezed
sealed class UserArguments with _$UserArguments {
  const factory UserArguments({
    String? fullName,
    String? email,
    String? phone,
  }) = _UserArguments;

  factory UserArguments.fromMap(Map<String, dynamic> map) {
    return UserArguments(
      fullName: map['fullName'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }
}

