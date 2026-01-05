import 'package:firebase_auth/firebase_auth.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';

class CompleteSignUpUseCase {
  CompleteSignUpUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Future<void> call() async {
    final user = _authRepository.currentUser;
    final userData = await _userRepository.getUserById(user?.uid ?? '');
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found',
      );
    }

    // Verify email is verified
    final isVerified = await _authRepository.isEmailVerified();
    if (!isVerified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Email not verified',
      );
    }

    // Create user document in Firestore
    await _userRepository.createUser(
      user.uid,
      name: userData?.name ?? '',
      email: userData?.email ?? '',
      phoneNumber: userData?.phoneNumber ?? '',
      emailVerified: true,
    );
  }
}

