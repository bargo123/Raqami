import 'package:flutter/material.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SignOutButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.colors.border),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.signoutIc.svg(),
          const SizedBox(width: 8),
          RaqamiText(
            AppLocalizations.of(context)!.signOut,
            style: RaqamiTextStyles.bodyLargeMedium,
            textColor: theme.colors.foregroundPrimary,
          ),
        ],
      ),
    );
  }
}

