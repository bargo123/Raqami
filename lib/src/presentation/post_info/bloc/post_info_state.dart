part of 'post_info_bloc.dart';

@freezed
sealed class PostInfoState with _$PostInfoState {
  const factory PostInfoState({
    required PostModel post,
    @Default(false) bool isLiking,
    @Default(false) bool isReporting,
    @Default(false) bool reportSuccess,
    String? error,
  }) = _PostInfoState;

  factory PostInfoState.initial(PostModel post) => PostInfoState(post: post);
}

