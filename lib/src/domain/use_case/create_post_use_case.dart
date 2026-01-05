import 'package:raqami/src/domain/models/line_type.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/post_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';

class CreatePostUseCase {
  CreatePostUseCase({
    required PostRepository postRepository,
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _postRepository = postRepository,
        _authRepository = authRepository,
        _userRepository = userRepository;

  final PostRepository _postRepository;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Future<PostModel> call({
    required String countryCode,
    required PostType type,
    required String number,
    required double price,
    required String currency,
    String? description,
    UAEEmirate? emirate,
    String? plateType,
    String? plateCode,
    PhoneProvider? phoneProvider,
    LineType? lineType,
  }) async {
    final user = _authRepository.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Get user data to get phone number and name
    final userData = await _userRepository.getUserById(user.uid);
    if (userData == null) {
      throw Exception('User data not found');
    }

    return await _postRepository.createPost(
      countryCode: countryCode,
      type: type,
      number: number,
      price: price,
      currency: currency,
      userId: user.uid,
      creatorPhoneNumber: userData.phoneNumber,
      creatorName: userData.name,
      description: description,
      emirate: emirate,
      plateType: plateType,
      plateCode: plateCode,
      phoneProvider: phoneProvider,
      lineType: lineType,
    );
  }
}

