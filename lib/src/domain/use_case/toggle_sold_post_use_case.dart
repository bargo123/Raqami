import 'package:raqami/src/domain/repositories/post_repository.dart';

class ToggleSoldPostUseCase {
  ToggleSoldPostUseCase({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  final PostRepository _postRepository;

  Future<void> call({
    required String postId,
    required bool sold,
  }) {
    return _postRepository.toggleSoldPost(postId, sold);
  }
}




