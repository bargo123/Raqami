import 'package:firebase_auth/firebase_auth.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/domain/repositories/user_repositotry.dart';

class SignUpWithEmailUseCase {
  SignUpWithEmailUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Future<void> call({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    final userExists = await _userRepository.checkUserExistsByEmail(email);
    if (userExists) {
      throw FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'An account with this email already exists',
      );
    }
  
    await _authRepository.signUpWithEmailAndPassword(
      email,
      password,
    );

    _userRepository.createUser(
      _authRepository.currentUser!.uid,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      emailVerified: false,
    );
    

    // Send verification email
    await _authRepository.sendEmailVerification();

  }
}

