part of 'my_posts_bloc.dart';

@freezed
sealed class MyPostsState with _$MyPostsState {
  const factory MyPostsState({
    @Default([]) List<PostModel> posts,
    @Default(false) bool isLoading,
    @Default(false) bool deleteSuccess,
    String? error,
  }) = _MyPostsState;

  factory MyPostsState.initial() => const MyPostsState();
}





