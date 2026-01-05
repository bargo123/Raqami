part of 'post_detail_bloc.dart';

@freezed
sealed class PostDetailEvent with _$PostDetailEvent {
  const factory PostDetailEvent.updatePost({
    required String postId,
    String? number,
    double? price,
    bool? sold,
    String? plateCode,
  }) = _UpdatePost;
  const factory PostDetailEvent.deletePost({
    required String postId,
  }) = _DeletePost;
  const factory PostDetailEvent.setNumberError({
    String? error,
  }) = _SetNumberError;
  const factory PostDetailEvent.setPlateCodeError({
    String? error,
  }) = _SetPlateCodeError;
  const factory PostDetailEvent.setPhoneCodeError({
    String? error,
  }) = _SetPhoneCodeError;
}

