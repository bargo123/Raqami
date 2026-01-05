import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    return RaqamiText(
      title,
      style: RaqamiTextStyles.bodySmallBold,
      textColor: theme.colors.foregroundSecondary,
    );
  }
}



