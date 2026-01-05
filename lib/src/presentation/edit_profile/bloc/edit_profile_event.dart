part of 'edit_profile_bloc.dart';

@freezed
class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.started(
    {String? fullName, String? email, String? phoneNumber}) = _Started;
  const factory EditProfileEvent.fullNameChanged(String fullName) = _FullNameChanged;
  const factory EditProfileEvent.emailChanged(String email) = _EmailChanged;
  const factory EditProfileEvent.phoneNumberChanged(String phoneNumber) = _PhoneNumberChanged;
  const factory EditProfileEvent.updateProfile() = _UpdateProfile;
}

