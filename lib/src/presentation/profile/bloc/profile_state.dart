part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
    @Default(0) int myPostsCount,
    @Default(0) int wishlistCount,
  }) = _ProfileState;

  factory ProfileState.initial() => const ProfileState();
}

