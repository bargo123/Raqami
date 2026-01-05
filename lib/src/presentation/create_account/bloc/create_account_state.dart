part of 'create_account_bloc.dart';

@freezed
sealed class CreateAccountState with _$CreateAccountState {
  const factory CreateAccountState({
    @Default('') String phoneNumber,
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool termsAccepted,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? phoneNumberError,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? termsError,
    String? generalError, // For network errors, server errors, etc.
  }) = _CreateAccountState;

  factory CreateAccountState.initial() => const CreateAccountState();
}

