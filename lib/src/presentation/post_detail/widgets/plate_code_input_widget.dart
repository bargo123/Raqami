import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PlateCodeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final UAEEmirate? emirate;
  final String? plateTypeString;
  final Function(String)? onChanged;
  final String? errorText;

  const PlateCodeInputWidget({
    super.key,
    required this.controller,
    this.emirate,
    this.plateTypeString,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    // Convert string plateType to PlateType enum
    PlateType? plateType;
    if (plateTypeString != null) {
      final typeString = plateTypeString!.toLowerCase();
      if (typeString == 'classic') {
        plateType = PlateType.classic;
      } else {
        plateType = PlateType.standard;
      }
    }
    // Get valid codes from PlateSelection
    final plateSelection = emirate != null && plateType != null
        ? PlateSelection(emirate: emirate!, plateType: plateType)
        : null;
    final validCodes = plateSelection?.validCodes ?? [];
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
        onChanged: (value) {
          if (value != null) {
            controller.text = value;
            onChanged?.call(value);
          }
        },
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.colors.foregroundSecondary,
          size: 20,
        ),
        iconSize: 20,
        isExpanded: true,
        dropdownColor: theme.colors.backgroundPrimary,
        style: RaqamiTextStyles.bodyBaseRegular.copyWith(
          color: theme.colors.foregroundPrimary,
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

