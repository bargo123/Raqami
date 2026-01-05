import 'package:flutter/material.dart';
import 'package:raqami/src/core/localization/numbers_arabic.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/widgets/svg_plate_widget.dart';

/// Unified widget for displaying license plate previews
/// Can be used in create post screen (with container) or home list (without container)
class PlatePreview extends StatelessWidget {
  // Option 1: Use PostModel
  final PostModel? post;
  
  // Option 2: Use individual parameters
  final String? plateNumber;
  final String? plateCode;
  final UAEEmirate? emirate;
  final String? plateTypeString;
  final PlateType? plateType;
  
  // Display options
  final bool showContainer; // Whether to wrap in styled container
  final Size? size; // Custom size (defaults to 400x80)

  /// Constructor for PostModel (used in home list)
  const PlatePreview.fromPost({
    super.key,
    required this.post,
    this.showContainer = false,
    this.size,
  })  : plateNumber = null,
        plateCode = null,
        emirate = null,
        plateTypeString = null,
        plateType = null;

  /// Constructor for individual parameters (used in create post)
  const PlatePreview({
    super.key,
    this.post,
    this.plateNumber,
    this.plateCode = '',
    this.emirate,
    this.plateTypeString,
    this.plateType,
    this.showContainer = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // If using PostModel
    if (post != null) {
      return Directionality(textDirection: TextDirection.ltr, child: _buildFromPost(context));
    }
    
    // If using individual parameters
    return Directionality(textDirection: TextDirection.ltr, child: _buildFromParameters(context));
  }

  Widget _buildFromPost(BuildContext context) {
    // Extract data from PostModel
    final postEmirate = post!.emirate;
    final postPlateType = post!.plateType;
    final postNumber = post!.number;
    final postPlateCode = post!.plateCode;

    // Use default emirate (Dubai) if none selected
    final displayEmirate = postEmirate ?? UAEEmirate.dubai;

    // Convert string plateType to PlateType enum
    PlateType? type;
    if (postPlateType != null) {
      final typeString = postPlateType.toLowerCase();
      if (typeString == 'classic') {
        type = PlateType.classic;
      } else {
        type = PlateType.standard;
      }
    }

    // Special handling for Abu Dhabi classic plates
    final displayNumber = displayEmirate == UAEEmirate.abuDhabi && type == PlateType.classic
        ? postNumber.arabicNumbers
        : postNumber;
    // Only show plate code if it exists and is not empty (trim whitespace)
    String? displayCode;
    if (displayEmirate == UAEEmirate.abuDhabi && type == PlateType.classic) {
      displayCode = postNumber;
    } else {
      // Check if plate code exists and has content after trimming
      if (postPlateCode != null && postPlateCode.trim().isNotEmpty) {
        displayCode = postPlateCode.trim();
      } else {
        displayCode = null;
      }
    }

    return _buildPlateWidget(
      context: context,
      emirate: displayEmirate,
      plateNumber: displayNumber,
      plateCode: displayCode,
      plateType: type,
    );
  }

  Widget _buildFromParameters(BuildContext context) {
    // Convert string plateType to PlateType enum
    PlateType? type = plateType;
    if (plateTypeString != null) {
      final typeString = plateTypeString!.toLowerCase();
      if (typeString == 'classic') {
        type = PlateType.classic;
      } else {
        type = PlateType.standard;
      }
    }

    // Use default emirate (Dubai) if none selected
    final displayEmirate = emirate ?? UAEEmirate.dubai;
    final displayPlateNumber = plateNumber ?? '';

    // Special handling for Abu Dhabi classic plates (same as PostModel)
    final finalNumber = displayEmirate == UAEEmirate.abuDhabi && type == PlateType.classic
        ? displayPlateNumber.arabicNumbers
        : displayPlateNumber;
    final finalCode = displayEmirate == UAEEmirate.abuDhabi && type == PlateType.classic
        ? displayPlateNumber
        : (plateCode?.isNotEmpty == true ? plateCode : null);

    return _buildPlateWidget(
      context: context,
      emirate: displayEmirate,
      plateNumber: finalNumber,
      plateCode: finalCode,
      plateType: type ?? PlateType.standard,
    );
  }

  Widget _buildPlateWidget({
    required BuildContext context,
    required UAEEmirate emirate,
    required String plateNumber,
    String? plateCode,
    PlateType? plateType,
  }) {
    final plateWidget = SvgPlateWidget(
      emirate: emirate,
      plateNumber: plateNumber,
      plateCode: plateCode,
      plateType: plateType ?? PlateType.standard,
      size: size ?? const Size(400, 80),
    );

    if (showContainer) {
      final theme = RaqamiTheme.of(context);
      return Container(
        decoration: BoxDecoration(
          color: theme.colors.neutral100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colors.border),
        ),
        padding: const EdgeInsets.all(8),
        child: Center(child: plateWidget),
      );
    }

    return plateWidget;
  }
}

