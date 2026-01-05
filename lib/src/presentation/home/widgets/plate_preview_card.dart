import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/widgets/plate_preview.dart';

/// Widget for displaying plate preview in home list (uses PostModel)
class PlatePreviewCard extends StatelessWidget {
  final PostModel post;
  final Size? size;

  const PlatePreviewCard({
    super.key,
    required this.post,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final plateSize = size ?? const Size(400, 100);

    return Directionality(textDirection: TextDirection.ltr,
      child: GestureDetector(
        onLongPress: () {
          // Copy plate number to clipboard on long press
          final plateNumber = post.number;
          final plateCode = post.plateCode?.trim();
          final fullPlate = plateCode != null && plateCode.isNotEmpty
              ? '$plateCode $plateNumber'
              : plateNumber;
          
          Clipboard.setData(ClipboardData(text: fullPlate));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Plate number copied'),
              duration: const Duration(seconds: 1),
              backgroundColor: theme.colors.statusSuccess,
            ),
          );
        },
        child: Container(
          width: plateSize.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colors.neutral100,
                theme.colors.neutral100.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colors.border,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label row with car icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 12,
                    color: theme.colors.foregroundSecondary.withOpacity(0.7),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      localizations?.carPlate ?? 'Car Plate',
                      style: RaqamiTextStyles.bodySmallRegular.copyWith(
                        fontSize: 10,
                        color: theme.colors.foregroundSecondary.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Plate Preview
              Center(
                child: PlatePreview.fromPost(
                  post: post,
                  showContainer: false,
                  size: Size(plateSize.width - 24, plateSize.height - 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

