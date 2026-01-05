import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/post_repository.dart';

class ToggleLikePostUseCase {
  ToggleLikePostUseCase({
    required PostRepository postRepository,
    required AuthRepository authRepository,
  })  : _postRepository = postRepository,
        _authRepository = authRepository;

  final PostRepository _postRepository;
  final AuthRepository _authRepository;

  Future<void> call(String postId) async {
    final user = _authRepository.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _postRepository.toggleLikePost(postId, user.uid);
  }
}

