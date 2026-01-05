import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raqami/src/core/utils/plate_svg_config.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';

/// Widget that displays a license plate using image template with overlaid text
class SvgPlateWidget extends StatelessWidget {
  final UAEEmirate emirate;
  final String plateNumber;
  final String? plateCode;
  final PlateType? plateType;
  final Size size;

  const SvgPlateWidget({
    super.key,
    required this.emirate,
    required this.plateNumber,
    this.plateCode,
    this.plateType,
    this.size = const Size(200, 100),
  });

  @override
  Widget build(BuildContext context) {
    final type = plateType ?? PlateType.standard;
    final config = PlateSvgConfig.getConfig(emirate, type);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          // Image background
          _buildImageWithErrorHandling(context, config.imagePath, size),
          // Left text (plate code) - only show if code exists and is not empty
          if (config.leftTextPosition != null && 
              plateCode != null && 
              plateCode!.trim().isNotEmpty)
            _buildTextOverlay(
              plateCode!.trim(),
              config.leftTextPosition!,
              size,
            ),
          // Right text (plate number)
          if (config.rightTextPosition != null)
            _buildTextOverlay(
              plateNumber,
              config.rightTextPosition!,
              size,
            ),
          // Center text (for some classic plates)
          if (config.centerTextPosition != null)
            _buildTextOverlay(
              plateNumber,
              config.centerTextPosition!,
              size,
            ),
        ],
      ),
    );
  }

  Widget _buildTextOverlay(
    String text,
    PlateTextPosition position,
    Size plateSize,
  ) {
    // Calculate font size based on plate height (device-independent)
    final fontSize = plateSize.height * position.fontSize;
    final verticalScale = position.verticalScale ?? 1.0;
    final textWidth = _getTextWidth(text, fontSize, position.fontWeight);
    final textHeight = fontSize * verticalScale; // Account for vertical scaling
    
    // Calculate position - x and y are fractions (0.0 to 1.0)
    final x = plateSize.width * position.x - textWidth / 2;
    final y = plateSize.height * position.y - textHeight / 2;

    Widget textWidget = Text(
      text,
      style: GoogleFonts.robotoMono(
        fontSize: fontSize,
        fontWeight: position.fontWeight,
        color: position.color ?? Colors.black,
        letterSpacing: position.letterSpacing ?? 3,
        height: 0.8,
        shadows: [
          // Embossed effect - strong light highlight (top-left)
          Shadow(
            offset: const Offset(-2, -2),
            blurRadius: 0,
            color: Colors.white.withOpacity(0.8),
          ),
          // Embossed effect - medium light highlight
          Shadow(
            offset: const Offset(-1, -1),
            blurRadius: 0,
            color: Colors.white.withOpacity(0.6),
          ),
          // Embossed effect - strong dark shadow (bottom-right)
          Shadow(
            offset: const Offset(2, 2),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.6),
          ),
          // Embossed effect - medium dark shadow
          Shadow(
            offset: const Offset(1, 1),
            blurRadius: 1,
            color: Colors.black.withOpacity(0.4),
          ),
        ],
      ),
    );


    // Apply vertical scaling if specified
    if (verticalScale != 1.0) {
      textWidget = Transform.scale(
        scaleY: verticalScale,
        alignment: Alignment.topCenter,
        child: textWidget,
      );
    }

    return Positioned(
      left: x.clamp(0.0, plateSize.width - textWidth),
      top: y.clamp(0.0, plateSize.height - textHeight),
      child: textWidget,
    );
  }

  double _getTextWidth(String text, double fontSize, FontWeight fontWeight) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.robotoMono(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  Widget _buildImageWithErrorHandling(BuildContext context, String imagePath, Size size) {
    return Image.asset(
      imagePath,
      width: size.width,
      height: size.height,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading image: $error');
        debugPrint('Image Path: $imagePath');
        // Show a colored container instead of grey to indicate error
        return Container(
          width: size.width,
          height: size.height,
          color: Colors.red.withOpacity(0.3),
          child: Center(
            child: Text(
              'Image Error',
              style: TextStyle(fontSize: 10, color: Colors.red),
            ),
          ),
        );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return frame == null
            ? Container(
                width: size.width,
                height: size.height,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : child;
      },
    );
  }
}

