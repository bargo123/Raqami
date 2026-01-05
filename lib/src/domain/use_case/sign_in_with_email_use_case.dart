import 'package:firebase_auth/firebase_auth.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';


class SignInWithEmailUseCase {
  SignInWithEmailUseCase({required AuthRepository authRepository, required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository;
  final AuthRepository _authRepository;
  final UserRepository _userRepository; 

  Future<bool?> call(String email, String password) async {
    final userExists = await _userRepository.checkUserExistsByEmail(email);
    if (!userExists) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found',
      );
    } 
    final userVerified = await _userRepository.checkUserVerifiedByEmail(email);
    await _authRepository.signInWithEmailAndPassword(email, password);
    if (!userVerified) {
      await _authRepository.sendEmailVerification();
    }
    return userVerified;
  }
}

