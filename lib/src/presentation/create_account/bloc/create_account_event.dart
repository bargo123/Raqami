part of 'create_account_bloc.dart';

@freezed
class CreateAccountEvent with _$CreateAccountEvent {
  const factory CreateAccountEvent.phoneNumberChanged(String phoneNumber) = _PhoneNumberChanged;
  const factory CreateAccountEvent.nameChanged(String name) = _NameChanged;
  const factory CreateAccountEvent.emailChanged(String email) = _EmailChanged;
  const factory CreateAccountEvent.passwordChanged(String password) = _PasswordChanged;
  const factory CreateAccountEvent.termsAcceptedChanged(bool accepted) = _TermsAcceptedChanged;
  const factory CreateAccountEvent.createAccount() = _CreateAccount;
  const factory CreateAccountEvent.emptyErrors() = _EmptyErrors;
}

