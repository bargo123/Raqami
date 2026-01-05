import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colors.neutral200,
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: theme.colors.neutral500,
            ),
          ),
          const SizedBox(width: 16),
          // Name and Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RaqamiText(
                  name,
                  style: RaqamiTextStyles.heading4,
                  textColor: theme.colors.foregroundPrimary,
                ),
                const SizedBox(height: 4),
                RaqamiText(
                  email,
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.foregroundSecondary,
                ),
              ],
            ),
          ),
          // Arrow Icon
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colors.foregroundSecondary,
          ),
        ],
      ),
    );
  }
}

