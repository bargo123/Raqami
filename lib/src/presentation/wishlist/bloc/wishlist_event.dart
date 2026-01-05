part of 'wishlist_bloc.dart';

@freezed
sealed class WishlistEvent with _$WishlistEvent {
  const factory WishlistEvent.loadLikedPosts({
    required String userId,
  }) = _LoadLikedPosts;
  const factory WishlistEvent.likePost({
    required String postId,
    required String userId,
  }) = _LikePost;
}





