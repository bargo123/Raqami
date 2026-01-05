import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/domain/repositories/post_repository.dart';

class GetPostsByTypeUseCase {
  GetPostsByTypeUseCase({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  final PostRepository _postRepository;

  // Stream<List<PostModel>> call({
  //   required String countryCode,
  //   required PostType postType,
  // }) {
  //   return _postRepository.getPostsByType(countryCode, postType);
  // }

  Future<({List<PostModel> posts, DocumentSnapshot? lastDocument, bool hasMore})> call({
    required String countryCode,
    required PostType postType,
    UAEEmirate? emirate,
    String? plateCode,
    int? digitCount,
    PhoneProvider? phoneProvider,
    String? phoneCode,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    return _postRepository.getPostsByTypePaginated(
      countryCode: countryCode,
      type: postType,
      emirate: emirate,
      plateCode: plateCode,
      digitCount: digitCount,
      phoneProvider: phoneProvider,
      phoneCode: phoneCode,
      lastDocument: lastDocument,
      limit: limit,
    );
  }
}

