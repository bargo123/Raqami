part of 'post_detail_bloc.dart';

@freezed
sealed class PostDetailState with _$PostDetailState {
  const factory PostDetailState({
    PostModel? post,
    @Default(false) bool isUpdating,
    @Default(false) bool isDeleting,
    @Default(false) bool isSuccess,
    String? error,
    String? numberError,
    String? plateCodeError,
    String? phoneCodeError,
  }) = _PostDetailState;

  factory PostDetailState.initial() => const PostDetailState();
}




