import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    return Column(
      children: [
        RaqamiText(
          value,
          style: RaqamiTextStyles.heading3,
          textColor: theme.colors.foregroundPrimary,
        ),
        const SizedBox(height: 4),
        RaqamiText(
          label,
          style: RaqamiTextStyles.bodySmallRegular,
          textColor: theme.colors.foregroundSecondary,
        ),
      ],
    );
  }
}



