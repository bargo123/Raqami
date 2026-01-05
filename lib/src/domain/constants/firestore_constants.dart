class FirestoreConstants {
  FirestoreConstants._();

  // Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String countriesCollection = 'countries';
  static const String reportsCollection = 'reports';
  
  // Country codes
  static const String countryCodeUAE = 'uae';

  // User fields
  static const String userFieldName = 'name';
  static const String userFieldEmail = 'email';
  static const String userFieldPhoneNumber = 'phoneNumber';
  static const String userFieldCreatedAt = 'createdAt';
  static const String userFieldUpdatedAt = 'updatedAt';
  static const String userFieldEmailVerified = 'emailVerified';

  // Post fields
  static const String postFieldType = 'type';
  static const String postFieldNumber = 'number';
  static const String postFieldPrice = 'price';
  static const String postFieldCurrency = 'currency';
  static const String postFieldDescription = 'description';
  static const String postFieldEmirate = 'emirate';
  static const String postFieldPlateType = 'plateType';
  static const String postFieldPlateCode = 'plateCode';
  static const String postFieldPhoneProvider = 'phoneProvider';
  static const String postFieldLineType = 'lineType';
  static const String postFieldUserId = 'userId';
  static const String postFieldCreatorPhoneNumber = 'creatorPhoneNumber';
  static const String postFieldCreatorName = 'creatorName';
  static const String postFieldLikedBy = 'likedBy';
  static const String postFieldSold = 'sold';
  static const String postFieldCreatedAt = 'createdAt';
  static const String postFieldUpdatedAt = 'updatedAt';

  // Report fields
  static const String reportFieldPostId = 'postId';
  static const String reportFieldReporterId = 'reporterId';
  static const String reportFieldReason = 'reason';
  static const String reportFieldAdditionalDetails = 'additionalDetails';
  static const String reportFieldCreatedAt = 'createdAt';
  static const String reportFieldStatus = 'status';
}

