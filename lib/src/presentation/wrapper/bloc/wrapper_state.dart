part of 'wrapper_bloc.dart';

@freezed
sealed class WrapperState with _$WrapperState {
  const factory WrapperState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    UserModel? userData,
    String? error,
  }) = _WrapperState;

  factory WrapperState.initial() => const WrapperState();
}



