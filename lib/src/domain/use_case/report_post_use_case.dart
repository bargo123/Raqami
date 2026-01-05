import 'package:raqami/src/domain/repositories/post_repository.dart';

class ReportPostUseCase {
  ReportPostUseCase({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  final PostRepository _postRepository;

  Future<void> call({
    required String postId,
    required String reporterId,
    required String reason,
    String? additionalDetails,
  }) {
    return _postRepository.reportPost(
      postId: postId,
      reporterId: reporterId,
      reason: reason,
      additionalDetails: additionalDetails,
    );
  }
}


