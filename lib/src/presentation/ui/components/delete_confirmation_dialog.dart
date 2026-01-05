import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

/// Shared delete confirmation dialog widget
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String? confirmText;
  final String? cancelText;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText,
    this.cancelText,
  });

  /// Show the delete confirmation dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  /// Show delete post confirmation dialog with localized strings
  static Future<void> showDeletePost({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return show(
      context: context,
      title: localizations.deletePost,
      message: localizations.areYouSureYouWantToDeleteThisPost,
      onConfirm: onConfirm,
      confirmText: localizations.delete,
      cancelText: localizations.cancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: theme.colors.backgroundSecondary,
      title: RaqamiText(
        title,
        style: RaqamiTextStyles.heading3,
        textColor: theme.colors.foregroundPrimary,
      ),
      content: RaqamiText(
        message,
        style: RaqamiTextStyles.bodyBaseRegular,
        textColor: theme.colors.foregroundSecondary,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: RaqamiText(
            cancelText ?? localizations.cancel,
            style: RaqamiTextStyles.bodyBaseSemibold,
            textColor: theme.colors.foregroundSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: RaqamiText(
            confirmText ?? localizations.delete,
            style: RaqamiTextStyles.bodyBaseSemibold,
            textColor: theme.colors.statusError,
          ),
        ),
      ],
    );
  }
}

