import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme_data.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class LanguageSelectionBottomSheet extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelectionBottomSheet({
    super.key,
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.backgroundPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: RaqamiText(
              localizations?.language ?? 'Language',
              style: RaqamiTextStyles.heading4,
              textColor: theme.colors.foregroundPrimary,
            ),
          ),
          
          // Language options
          _buildLanguageOption(
            context,
            theme,
            'English',
            'en',
            Icons.language,
          ),
          _buildLanguageOption(
            context,
            theme,
            'العربية',
            'ar',
            Icons.language,
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    RaqamiThemeData theme,
    String languageName,
    String languageCode,
    IconData icon,
  ) {
    final isSelected = currentLanguage == languageCode;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
            ? theme.colors.tertiary.withOpacity(0.1) 
            : theme.colors.backgroundSecondary,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            onLanguageSelected(languageCode);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? theme.colors.tertiary : theme.colors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? theme.colors.tertiary : theme.colors.foregroundSecondary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RaqamiText(
                    languageName,
                    style: RaqamiTextStyles.bodyBaseSemibold.copyWith(
                      color: isSelected 
                          ? theme.colors.tertiary 
                          : theme.colors.foregroundPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colors.tertiary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

