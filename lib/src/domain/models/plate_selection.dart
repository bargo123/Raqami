import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/domain/models/plate_type.dart';

class PlateSelection {
  final UAEEmirate emirate;
  final PlateType plateType;

  const PlateSelection({
    required this.emirate,
    required this.plateType,
  });

  String get imagePath {
    // Map emirate names to actual image file names
    String fileName;
    switch (emirate) {
      case UAEEmirate.dubai:
        fileName = plateType == PlateType.classic ? 'dubai_classic' : 'dubai';
        break;
      case UAEEmirate.abuDhabi:
        fileName = plateType == PlateType.classic ? 'abu_dahbi_clasic' : 'abu_dahbi';
        break;
      case UAEEmirate.sharjah:
        fileName = plateType == PlateType.classic ? 'calssic_sharjah' : 'sharjah';
        break;
      case UAEEmirate.ummAlQuwain:
        fileName = 'om_alqewan';
        break;
      case UAEEmirate.rasAlKhaimah:
        fileName = 'ras_alkhemeh';
        break;
      case UAEEmirate.fujairah:
        fileName = 'alfujerah';
        break;
      case UAEEmirate.ajman:
        fileName = 'ajman'; // Assuming this exists or will be added
        break;
    }
    return 'assets/images/plates/$fileName.png';
  }

  String get displayName {
    if (plateType == PlateType.classic) {
      return '${emirate.name} Classic';
    }
    return emirate.name;
  }

  String get arabicDisplayName {
    if (plateType == PlateType.classic) {
      return '${emirate.arabicName} كلاسيك';
    }
    return emirate.arabicName;
  }

  bool get requiresCode {
    // Classic plates don't require codes
    if (plateType == PlateType.classic) {
      return false;
    }
    return true;
  }

  List<String> get validCodes {
    if (!requiresCode) return [];
    
    switch (emirate) {
      case UAEEmirate.dubai:
        return List.generate(26, (i) => String.fromCharCode(65 + i)); // A-Z
      case UAEEmirate.abuDhabi:
        return [
          ...List.generate(22, (i) => (i + 1).toString()), // 1-22
          '50',
        ];
      case UAEEmirate.sharjah:
        return List.generate(4, (i) => (i + 1).toString()); // 1-4
      case UAEEmirate.rasAlKhaimah:
        return List.generate(26, (i) => String.fromCharCode(65 + i)); // A-Z
      case UAEEmirate.ummAlQuwain:
        return List.generate(26, (i) => String.fromCharCode(65 + i)); // A-Z
      case UAEEmirate.fujairah:
        return List.generate(26, (i) => String.fromCharCode(65 + i)); // A-Z
      case UAEEmirate.ajman:
        return [
          '?', // Question mark
          ...List.generate(26, (i) => String.fromCharCode(65 + i)), // A-Z
        ];
    }
  }

  bool isValidCode(String code) {
    if (!requiresCode) return true;
    return validCodes.contains(code.toUpperCase());
  }
}

