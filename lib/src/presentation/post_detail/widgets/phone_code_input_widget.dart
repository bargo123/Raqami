import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PhoneCodeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final PhoneProvider? phoneProvider;
  final Function(String)? onChanged;
  final String? errorText;

  const PhoneCodeInputWidget({
    super.key,
    required this.controller,
    this.phoneProvider,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final validCodes = phoneProvider?.validCodes ?? [];
    final currentCode = controller.text.isEmpty ? null : controller.text;

    return SizedBox(
      height: 56,
      child: DropdownButtonFormField<String>(
        value: currentCode,
        decoration: InputDecoration(
          hintText: localizations.code,
          hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.neutral500,
          ),
          filled: true,
          fillColor: theme.colors.backgroundSecondary,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: errorText != null
                  ? theme.colors.statusError
                  : theme.colors.border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: errorText != null
                  ? theme.colors.statusError
                  : theme.colors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: errorText != null
                  ? theme.colors.statusError
                  : theme.colors.foregroundPrimary,
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
        ),
        items: validCodes.map((code) {
          return DropdownMenuItem<String>(
            value: code,
            child: Align(
              alignment: Alignment.center,
              child: RaqamiText(
                code,
                style: RaqamiTextStyles.bodyBaseRegular,
                textColor: theme.colors.foregroundPrimary,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
        onChanged: phoneProvider != null && validCodes.isNotEmpty
            ? (value) {
                if (value != null) {
                  controller.text = value;
                  onChanged?.call(value);
                }
              }
            : null,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: phoneProvider != null && validCodes.isNotEmpty
              ? theme.colors.foregroundSecondary
              : theme.colors.foregroundDisabled,
          size: 20,
        ),
        iconSize: 20,
        isExpanded: true,
        dropdownColor: theme.colors.backgroundPrimary,
        style: RaqamiTextStyles.bodyBaseRegular.copyWith(
          color: phoneProvider != null && validCodes.isNotEmpty
              ? theme.colors.foregroundPrimary
              : theme.colors.foregroundDisabled,
        ),
        selectedItemBuilder: (BuildContext context) {
          return validCodes.map<Widget>((String code) {
            return SizedBox(
              width: double.infinity,
              child: Center(
                child: RaqamiText(
                  code,
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.foregroundPrimary,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}

