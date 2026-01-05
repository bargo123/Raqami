import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PlateNumberInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? errorText;

  const PlateNumberInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        style: RaqamiTextStyles.bodyBaseRegular,
        keyboardType: TextInputType.number,
        maxLength: 5,
        decoration: InputDecoration(
          hintText: localizations.number,
          hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.neutral500,
          ),
          filled: true,
          fillColor: theme.colors.backgroundSecondary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.foregroundPrimary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.statusError,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.statusError,
              width: 1.5,
            ),
          ),
          errorText: errorText,
          errorStyle: RaqamiTextStyles.bodySmallRegular.copyWith(
            color: theme.colors.statusError,
          ),
          counterText: '',
        ),
        onChanged: onChanged,
      ),
    );
  }
}



