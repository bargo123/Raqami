import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/domain/models/plate_type.dart';

enum UAEEmirate {
  abuDhabi,
  dubai,
  sharjah,
  ajman,
  ummAlQuwain,
  rasAlKhaimah,
  fujairah,
}

extension UAEEmirateExtension on UAEEmirate {
  String get name {
    switch (this) {
      case UAEEmirate.abuDhabi:
        return 'Abu Dhabi';
      case UAEEmirate.dubai:
        return 'Dubai';
      case UAEEmirate.sharjah:
        return 'Sharjah';
      case UAEEmirate.ajman:
        return 'Ajman';
      case UAEEmirate.ummAlQuwain:
        return 'Umm Al Quwain';
      case UAEEmirate.rasAlKhaimah:
        return 'Ras Al Khaimah';
      case UAEEmirate.fujairah:
        return 'Fujairah';
    }
  }

  String get arabicName {
    switch (this) {
      case UAEEmirate.abuDhabi:
        return 'أبو ظبي';
      case UAEEmirate.dubai:
        return 'دبي';
      case UAEEmirate.sharjah:
        return 'الشارقة';
      case UAEEmirate.ajman:
        return 'عجمان';
      case UAEEmirate.ummAlQuwain:
        return 'أم القيوين';
      case UAEEmirate.rasAlKhaimah:
        return 'رأس الخيمة';
      case UAEEmirate.fujairah:
        return 'الفجيرة';
    }
  }

  String get platePrefix {
    switch (this) {
      case UAEEmirate.abuDhabi:
        return 'أ';
      case UAEEmirate.dubai:
        return 'د';
      case UAEEmirate.sharjah:
        return 'ش';
      case UAEEmirate.ajman:
        return 'ع';
      case UAEEmirate.ummAlQuwain:
        return 'أم';
      case UAEEmirate.rasAlKhaimah:
        return 'ر';
      case UAEEmirate.fujairah:
        return 'ف';
    }
  }

  // Get all available plate selections for this emirate
  List<PlateSelection> get plateSelections {
    return [
      PlateSelection(emirate: this, plateType: PlateType.standard),
      if (this == UAEEmirate.dubai || 
          this == UAEEmirate.abuDhabi)
        PlateSelection(emirate: this, plateType: PlateType.classic),
    ];
  }
}

