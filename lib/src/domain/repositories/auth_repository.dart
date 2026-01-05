import 'package:firebase_auth/firebase_auth.dart';
class AuthRepository {
  AuthRepository({
    required FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
       await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      return;
    }
  }

  /// Check if email is verified
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // First reload to refresh user data
      await user.reload();
      // Get fresh user instance after first reload
      final refreshedUser = _firebaseAuth.currentUser;
      if (refreshedUser != null) {
        // Second reload to ensure we have the latest verification status
        await refreshedUser.reload();
        // Get the final fresh user instance with updated verification status
        final finalUser = _firebaseAuth.currentUser;
        return finalUser?.emailVerified ?? false;
      }
      return false;
    }
    return false;
  }
}
