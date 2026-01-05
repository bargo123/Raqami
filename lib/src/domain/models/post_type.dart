enum PostType {
  phoneNumber,
  carPlate,
}

extension PostTypeExtension on PostType {
  String get displayName {
    switch (this) {
      case PostType.phoneNumber:
        return 'Phone Number';
      case PostType.carPlate:
        return 'Car Plate';
    }
  }
}

