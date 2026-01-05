import 'package:raqami/src/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.signOut();
  }
}

