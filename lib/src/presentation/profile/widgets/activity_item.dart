import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback? onTap;

  const ActivityItem({
    super.key,
    required this.icon,
    required this.title,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: theme.colors.foregroundPrimary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RaqamiText(
                title,
                style: RaqamiTextStyles.bodyBaseRegular,
                textColor: theme.colors.foregroundPrimary,
              ),
            ),
            if (badge != null) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colors.tertiary,
                ),
                child: Center(
                  child: RaqamiText(
                    badge!,
                    style: RaqamiTextStyles.bodySmallRegular.copyWith(
                      color: theme.colors.secondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colors.foregroundSecondary,
            ),
          ],
        ),
      ),
    );
  }
}



