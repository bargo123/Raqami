import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String name,
    required String email,
    required String phoneNumber,
    @Default(false) bool emailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;



  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data[FirestoreConstants.userFieldName] as String,
      email: data[FirestoreConstants.userFieldEmail] as String,
      phoneNumber: data[FirestoreConstants.userFieldPhoneNumber] as String,
      emailVerified: data[FirestoreConstants.userFieldEmailVerified] as bool? ?? false,
      createdAt: (data[FirestoreConstants.userFieldCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data[FirestoreConstants.userFieldUpdatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

extension UserModelExtension on UserModel {
  Map<String, dynamic> toFirestore() {
    return {
      FirestoreConstants.userFieldName: name,
      FirestoreConstants.userFieldEmail: email,
      FirestoreConstants.userFieldPhoneNumber: phoneNumber,
      FirestoreConstants.userFieldEmailVerified: emailVerified,
      FirestoreConstants.userFieldCreatedAt: FieldValue.serverTimestamp(),
      FirestoreConstants.userFieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
}
