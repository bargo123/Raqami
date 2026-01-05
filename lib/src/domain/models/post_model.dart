import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';
import 'package:raqami/src/domain/models/line_type.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
sealed class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required PostType type,
    required String number, // Phone number or plate number
    required double price,
    required String currency, // AED
    String? description,
    // For car plates
    UAEEmirate? emirate,
    String? plateType, // e.g., "Standard", "Premium", "Single Digit"
    String? plateCode, // Plate code (A-Z or 1-22, etc.)
    // For phone numbers
    PhoneProvider? phoneProvider, // du, etisalat, virgin
    LineType? lineType, // prepaid, postpaid
    // Metadata
    required String userId,
    required String creatorPhoneNumber, // Phone number of the person who created the post
    required String creatorName, // Name of the person who created the post
    @Default([]) List<String> likedBy, // List of user IDs who liked this post
    @Default(false) bool sold, // Whether the post has been sold
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      type: PostType.values.firstWhere(
        (e) => e.name == data[FirestoreConstants.postFieldType],
        orElse: () => PostType.phoneNumber,
      ),
      number: data[FirestoreConstants.postFieldNumber] as String,
      price: (data[FirestoreConstants.postFieldPrice] as num).toDouble(),
      currency: data[FirestoreConstants.postFieldCurrency] as String,
      description: data[FirestoreConstants.postFieldDescription] as String?,
      emirate: data[FirestoreConstants.postFieldEmirate] != null
          ? UAEEmirate.values.firstWhere(
              (e) => e.name == data[FirestoreConstants.postFieldEmirate],
              orElse: () => UAEEmirate.dubai,
            )
          : null,
      plateType: data[FirestoreConstants.postFieldPlateType] as String?,
      plateCode: data[FirestoreConstants.postFieldPlateCode] as String?,
      phoneProvider: data[FirestoreConstants.postFieldPhoneProvider] != null
          ? PhoneProvider.values.firstWhere(
              (e) => e.name == data[FirestoreConstants.postFieldPhoneProvider],
              orElse: () => PhoneProvider.du,
            )
          : null,
      lineType: data[FirestoreConstants.postFieldLineType] != null
          ? LineType.values.firstWhere(
              (e) => e.name == data[FirestoreConstants.postFieldLineType],
              orElse: () => LineType.prepaid,
            )
          : null,
      userId: data[FirestoreConstants.postFieldUserId] as String,
      creatorPhoneNumber: data[FirestoreConstants.postFieldCreatorPhoneNumber] as String,
      creatorName: data[FirestoreConstants.postFieldCreatorName] as String,
      likedBy: List<String>.from(data[FirestoreConstants.postFieldLikedBy] ?? []),
      sold: data[FirestoreConstants.postFieldSold] as bool? ?? false,
      createdAt: (data[FirestoreConstants.postFieldCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data[FirestoreConstants.postFieldUpdatedAt] as Timestamp?)?.toDate(),
    );
  }
}

extension PostModelExtension on PostModel {
  Map<String, dynamic> toFirestore() {
    return {
      FirestoreConstants.postFieldType: type.name,
      FirestoreConstants.postFieldNumber: number,
      FirestoreConstants.postFieldPrice: price,
      FirestoreConstants.postFieldCurrency: currency,
      if (description != null)
        FirestoreConstants.postFieldDescription: description,
      if (emirate != null)
        FirestoreConstants.postFieldEmirate: emirate!.name,
      if (plateType != null)
        FirestoreConstants.postFieldPlateType: plateType,
      if (plateCode != null)
        FirestoreConstants.postFieldPlateCode: plateCode,
      if (phoneProvider != null)
        FirestoreConstants.postFieldPhoneProvider: phoneProvider!.name,
      if (lineType != null)
        FirestoreConstants.postFieldLineType: lineType!.name,
      FirestoreConstants.postFieldUserId: userId,
      FirestoreConstants.postFieldCreatorPhoneNumber: creatorPhoneNumber,
      FirestoreConstants.postFieldCreatorName: creatorName,
      FirestoreConstants.postFieldLikedBy: likedBy,
      FirestoreConstants.postFieldSold: sold,
      FirestoreConstants.postFieldCreatedAt: FieldValue.serverTimestamp(),
      FirestoreConstants.postFieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
}

