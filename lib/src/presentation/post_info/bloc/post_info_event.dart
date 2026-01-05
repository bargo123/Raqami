part of 'post_info_bloc.dart';

@freezed
sealed class PostInfoEvent with _$PostInfoEvent {
  const factory PostInfoEvent.initialize({
    required PostModel post,
  }) = _Initialize;
  
  const factory PostInfoEvent.likePost({
    required String userId,
  }) = _LikePost;
  
  const factory PostInfoEvent.reportPost({
    required String postId,
    required String reporterId,
    required String reason,
    String? additionalDetails,
  }) = _ReportPost;
}

