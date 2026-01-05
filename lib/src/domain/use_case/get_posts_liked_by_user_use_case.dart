import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/repositories/post_repository.dart';

class GetPostsLikedByUserUseCase {
  GetPostsLikedByUserUseCase({
    required PostRepository postRepository,
  })  : _postRepository = postRepository;

  final PostRepository _postRepository;

  Stream<List<PostModel>> call(
   { required String userId, }
  ) {
    return _postRepository.getPostsLikedByUser(userId);
  }


}

