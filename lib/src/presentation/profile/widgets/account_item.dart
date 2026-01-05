import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class AccountItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const AccountItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final isEnabled = onTap != null;
    
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colors.neutral100,
              ),
              child: Center(
                child: icon,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RaqamiText(
                    title,
                    style: RaqamiTextStyles.bodyBaseRegular,
                    textColor: theme.colors.foregroundPrimary,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    RaqamiText(
                      subtitle!,
                      style: RaqamiTextStyles.bodySmallRegular,
                      textColor: theme.colors.foregroundSecondary,
                    ),
                  ],
                ],
              ),
            ),
            if (isEnabled)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colors.foregroundSecondary,
              ),
          ],
        ),
      ),
      ),
    );
  }
}

