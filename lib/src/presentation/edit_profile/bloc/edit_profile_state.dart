part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String phoneNumber,
    String? fullNameError,
    String? emailError,
    String? phoneNumberError,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
  }) = _EditProfileState;

  factory EditProfileState.initial() => const EditProfileState();
}

