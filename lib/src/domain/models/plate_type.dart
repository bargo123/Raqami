enum PlateType {
  standard,
  classic,
}

extension PlateTypeExtension on PlateType {
  String get name {
    switch (this) {
      case PlateType.standard:
        return 'Standard';
      case PlateType.classic:
        return 'Classic';
    }
  }
}

