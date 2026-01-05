import 'package:raqami/src/data/models/models/user_model.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';

class GetUserDataUseCase {
  GetUserDataUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Stream<UserModel?> call() {
    return _userRepository.getUserByIdStream(_authRepository.currentUser?.uid ?? '');
  }
}