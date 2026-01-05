import 'package:raqami/src/domain/repositories/post_repository.dart';

class DeletePostUseCase {
  DeletePostUseCase({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  final PostRepository _postRepository;

  Future<void> call({
    required String postId,
  }) {
    return _postRepository.deletePost(postId);
  }
}

