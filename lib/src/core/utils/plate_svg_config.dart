import 'package:flutter/material.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';

/// Configuration for plate image templates and text positioning
class PlateSvgConfig {
  final String imagePath;
  final PlateTextPosition? leftTextPosition;
  final PlateTextPosition? rightTextPosition;
  final PlateTextPosition? centerTextPosition;
  final bool isClassic;

  const PlateSvgConfig({
    required this.imagePath,
    this.leftTextPosition,
    this.rightTextPosition,
    this.centerTextPosition,
    this.isClassic = false,
  });

  /// Get image path for emirate and plate type
  static String getImagePath(UAEEmirate emirate, PlateType plateType) {
    final isClassic = plateType == PlateType.classic;
    
    switch (emirate) {
      case UAEEmirate.dubai:
        return isClassic
            ? 'assets/images/full_plates/dubai_classic.png'
            : 'assets/images/full_plates/dubai.png';
      case UAEEmirate.abuDhabi:
        return isClassic
            ? 'assets/images/full_plates/abu_dhabi_classic.png'
            : 'assets/images/full_plates/abu_dhabi.png';
      case UAEEmirate.sharjah:
        return 'assets/images/full_plates/sharjah.png';
      case UAEEmirate.ummAlQuwain:
        return 'assets/images/full_plates/om_elqewan.png';
      case UAEEmirate.rasAlKhaimah:
        return 'assets/images/full_plates/ras_alkhemeh.png';
      case UAEEmirate.fujairah:
        return 'assets/images/full_plates/alfujerah.png';
      case UAEEmirate.ajman:
        return 'assets/images/full_plates/ajman.png';
    }
  }

  /// Get text positions for emirate and plate type
  static PlateSvgConfig getConfig(UAEEmirate emirate, PlateType plateType) {
    final isClassic = plateType == PlateType.classic;
    final imagePath = getImagePath(emirate, plateType);

    switch (emirate) {
      case UAEEmirate.dubai:
        if (isClassic) {
          // Dubai Classic: numbers on right side
          return PlateSvgConfig(
            imagePath: imagePath,
            rightTextPosition: PlateTextPosition(
              x: 0.48, // 65% from left
              y: 0.5, // Center vertically
              fontSize: 0.5, // 42% of plate height - large embossed numbers
              fontWeight: FontWeight.w600,
              verticalScale: 1.5
            ),
            isClassic: true,
          );
        } else {
          // Dubai Standard: letter on left, numbers on right
          return PlateSvgConfig(
            imagePath: imagePath,
            leftTextPosition: PlateTextPosition(
              x: 0.11, // 15% from left
              y: 0.7, // Center vertically
              fontSize: 0.4, // 25% of plate height
              fontWeight: FontWeight.w600,
              verticalScale: 1.1
            ),
            rightTextPosition: PlateTextPosition(
              x: 0.48, // 65% from left
              y: 0.5, // Center vertically
              fontSize: 0.5, // 38% of plate height - large embossed numbers
              fontWeight: FontWeight.w600,
              verticalScale: 1.5
            ),
          );
        }

      case UAEEmirate.abuDhabi:
        if (isClassic) {
          // Abu Dhabi Classic: numbers on both sides (English and Arabic)
          return PlateSvgConfig(
            imagePath: imagePath,
            leftTextPosition: PlateTextPosition(
              x: 0.14, // 15% from left
              y: 0.5,
              fontSize: 0.3,
              fontWeight: FontWeight.w600,
              verticalScale: 1.5
            ),
            rightTextPosition: PlateTextPosition(
              x: 0.65, // 65% from left
              y: 0.56,
              fontSize: 0.3,
              fontWeight: FontWeight.w600,
              verticalScale: 1.5
            ),
            isClassic: true,
          );
        } else {
          // Abu Dhabi Standard: code on left, numbers on right
          return PlateSvgConfig(
            imagePath: imagePath,
            leftTextPosition: PlateTextPosition(
              x: 0.08, // 15% from left
              y: 0.35, // Upper part
              fontSize: 0.3,
              fontWeight: FontWeight.w600,
              verticalScale: 1.5, // Incease height by 50% (adjust this value to make numbers taller)
            ),
            rightTextPosition: PlateTextPosition(
              x: 0.5, // 65% from left
              y: 0.5, // Center
              fontSize: 0.4,
              fontWeight: FontWeight.w600,
              verticalScale: 2, // Incease height by 50% (adjust this value to make numbers taller)
            ),
          );
        }

      case UAEEmirate.sharjah:
        // Sharjah: code on left, numbers on right
        return PlateSvgConfig(
          imagePath: imagePath,
          leftTextPosition: PlateTextPosition(
            x: 0.14, // 10% from left
            y: 0.5,
            fontSize: 0.3,
            fontWeight: FontWeight.w600,
            verticalScale: 1.5
          ),
          rightTextPosition: PlateTextPosition(
            x: 0.6, // 70% from left
            y: 0.5,
            fontSize: 0.4,
            fontWeight: FontWeight.w600,
          ),
        );

      case UAEEmirate.ummAlQuwain:
        // Umm Al Quwain: letter on left, numbers on right
        return PlateSvgConfig(
          imagePath: imagePath,
          leftTextPosition: PlateTextPosition(
            x: 0.1, // 10% from left
            y: 0.5,
            fontSize: 0.25,
            fontWeight: FontWeight.w900,
          ),
          rightTextPosition: PlateTextPosition(
            x: 0.65, // 65% from left
            y: 0.5,
            fontSize: 0.28,
            fontWeight: FontWeight.w900,
          ),
        );

      case UAEEmirate.rasAlKhaimah:
        // Ras Al Khaimah: Arabic text in background, letter code in middle-left, numbers on right
        return PlateSvgConfig(
          imagePath: imagePath,
          leftTextPosition: PlateTextPosition(
            x: 0.28, // 38% from left - after Arabic text area
            y: 0.5,
            fontSize: 0.4, // 35% of plate height - large embossed letter
            fontWeight: FontWeight.w600,
            verticalScale: 2, // Incease height by 50% (adjust this value to make numbers taller)
          ),
          rightTextPosition: PlateTextPosition(
            x: 0.55, // 78% from left - far right for numbers
            y: 0.5,
            fontSize: 0.4, // 42% of plate height - large embossed numbers
            fontWeight: FontWeight.w600,
            verticalScale: 2, // Incease height by 50% (adjust this value to make numbers taller)
          ),
        );

      case UAEEmirate.fujairah:
        // Fujairah: code on left, numbers on right
        return PlateSvgConfig(
          imagePath: imagePath,
          leftTextPosition: PlateTextPosition(
            x: 0.1, // 10% from left
            y: 0.5,
            fontSize: 0.4, // 35% of plate height - large embossed letter
            fontWeight: FontWeight.w600,
                        verticalScale: 1.5

          ),
          rightTextPosition: PlateTextPosition(
            x: 0.58, // 70% from left
            y: 0.5,
            fontSize: 0.4, // 35% of plate height - large embossed letter
            fontWeight: FontWeight.w600,
            verticalScale: 1.5
          ),
        );

      case UAEEmirate.ajman:
        // Ajman: letter on left, numbers on right
        return PlateSvgConfig(
          imagePath: imagePath,
          leftTextPosition: PlateTextPosition(
            x: 0.1, // 10% from left
            y: 0.5,
            fontSize: 0.4,
            fontWeight: FontWeight.w600,
            verticalScale: 1.5
          ),
          rightTextPosition: PlateTextPosition(
            x: 0.35, // 65% from left
            y: 0.5,
            fontSize: 0.4,
            fontWeight: FontWeight.w600,
            verticalScale: 1.5
          ),
        );
    }
  }
}

/// Text position configuration for plate numbers/codes
class PlateTextPosition {
  final double x; // X position as fraction of width (0.0 to 1.0)
  final double y; // Y position as fraction of height (0.0 to 1.0)
  final double fontSize; // Font size as fraction of plate height
  final FontWeight fontWeight;
  final Color? color;
  final double? letterSpacing; // Letter spacing (can be negative)
  final double? verticalScale; // Vertical scale factor to increase height (e.g., 1.5 = 50% taller)

  const PlateTextPosition({
    required this.x,
    required this.y,
    required this.fontSize,
    this.fontWeight = FontWeight.w700,
    this.color,
    this.letterSpacing,
    this.verticalScale, // Defaults to 1.0 if not specified
  });
}

