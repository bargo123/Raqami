part of 'my_posts_bloc.dart';

@freezed
sealed class MyPostsEvent with _$MyPostsEvent {
  const factory MyPostsEvent.loadMyPosts({
    required String userId,
  }) = _LoadMyPosts;
  const factory MyPostsEvent.toggleSold({
    required String postId,
    required String userId,
    required bool sold,
  }) = _ToggleSold;
  const factory MyPostsEvent.deletePost({
    required String postId,
  }) = _DeletePost;
}




