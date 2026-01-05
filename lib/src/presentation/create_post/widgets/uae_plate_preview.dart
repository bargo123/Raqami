import 'package:flutter/material.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/presentation/widgets/plate_preview.dart';

/// Widget for displaying plate preview in create post screen (with container)
class UAEPlatePreview extends StatelessWidget {
  final String plateNumber;
  final String plateCode;
  final UAEEmirate? emirate;
  final String? plateType;

  const UAEPlatePreview({
    super.key,
    required this.plateNumber,
    this.plateCode = '',
    this.emirate,
    this.plateType,
  });

  @override
  Widget build(BuildContext context) {
    return PlatePreview(
      plateNumber: plateNumber,
      plateCode: plateCode,
      emirate: emirate,
      plateTypeString: plateType,
      showContainer: true,
    );
  }
}
