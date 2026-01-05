import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';
import 'package:raqami/src/data/models/models/user_model.dart';

class UserRepository {
  UserRepository({
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super();
  final FirebaseFirestore _firestore;


  /// Check if user exists by email
  Future<bool> checkUserExistsByEmail(String email) async {
    final userDoc = await _firestore
        .collection(FirestoreConstants.usersCollection)
        .where(FirestoreConstants.userFieldEmail, isEqualTo: email)
        .get();
    return userDoc.docs.isNotEmpty;
  }

  /// Check if user is verified by email
  Future<bool> checkUserVerifiedByEmail(String email) async {
    try {
      final userDoc = await _firestore
        .collection(FirestoreConstants.usersCollection)
        .where(FirestoreConstants.userFieldEmail, isEqualTo: email)
        .get();
      return userDoc.docs.first.data()[FirestoreConstants.userFieldEmailVerified] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Create user document in Firestore
  Future<void> createUser(
    String uid, {
    required String name,
    required String email,
    required String phoneNumber,
    required bool emailVerified,
  }) async {
    final userModel = UserModel(
      uid: uid,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      emailVerified: emailVerified,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(uid)
        .set(userModel.toFirestore());
  }

  /// Get user by ID from Firestore
  Future<UserModel?> getUserById(String uid) async {
    try {
      final userDoc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get user by ID stream from Firestore
  Stream<UserModel?> getUserByIdStream(String uid) {
    return _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((userDoc) {
      try {
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        }
        return null;
      } catch (e) {
        return null;
      }
    });
  }

  Future<void> updateUser(
    String uid, {
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(uid)
        .update({
      FirestoreConstants.userFieldName: name,
      FirestoreConstants.userFieldEmail: email,
      FirestoreConstants.userFieldPhoneNumber: phoneNumber,
      FirestoreConstants.userFieldUpdatedAt: FieldValue.serverTimestamp(),
    });
  }

}