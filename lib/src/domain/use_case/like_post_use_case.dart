import 'package:raqami/src/domain/repositories/post_repository.dart';

class LikePostUseCase {
  LikePostUseCase({
    required PostRepository postRepository,
  })  : _postRepository = postRepository;

  final PostRepository _postRepository;

  Future<void> call({
    required String postId,
    required String userId,
  }) async {
    await _postRepository.toggleLikePost(postId, userId);
  }
}