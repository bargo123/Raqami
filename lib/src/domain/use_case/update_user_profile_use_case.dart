import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';

class UpdateUserProfileUseCase {
  UpdateUserProfileUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Future<void> call({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final user = _authRepository.currentUser;
    if (user == null) {
      throw Exception('User not found');
    }

    await _userRepository.updateUser(
      user.uid,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}


