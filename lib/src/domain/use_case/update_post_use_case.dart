import 'package:raqami/src/domain/repositories/post_repository.dart';

class UpdatePostUseCase {
  UpdatePostUseCase({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  final PostRepository _postRepository;

  Future<void> call({
    required String postId,
    String? number,
    double? price,
    bool? sold,
    String? plateCode,
  }) {
    return _postRepository.updatePost(
      postId: postId,
      number: number,
      price: price,
      sold: sold,
      plateCode: plateCode,
    );
  }
}






