enum LineType {
  prepaid,
  postpaid,
}

extension LineTypeExtension on LineType {
  String get name {
    switch (this) {
      case LineType.prepaid:
        return 'prepaid';
      case LineType.postpaid:
        return 'postpaid';
    }
  }
}

