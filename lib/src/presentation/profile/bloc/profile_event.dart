part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.signOut() = _SignOut;
  const factory ProfileEvent.loadMyPostsCount({
    required String userId,
  }) = _LoadMyPostsCount;
  const factory ProfileEvent.loadWishlistCount({
    required String userId,
  }) = _LoadWishlistCount;
}

