import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class ReportPostDialog extends StatefulWidget {
  final Function(String reason, String? additionalDetails) onReport;

  const ReportPostDialog({
    super.key,
    required this.onReport,
  });

  @override
  State<ReportPostDialog> createState() => _ReportPostDialogState();
}

class _ReportPostDialogState extends State<ReportPostDialog> {
  String? _selectedReason;
  final TextEditingController _additionalDetailsController = TextEditingController();

  final List<Map<String, String>> _reportReasons = [
    {'key': 'spam', 'en': 'Spam', 'ar': 'بريد عشوائي'},
    {'key': 'inappropriate', 'en': 'Inappropriate Content', 'ar': 'محتوى غير لائق'},
    {'key': 'misleading', 'en': 'Misleading Information', 'ar': 'معلومات مضللة'},
    {'key': 'fraud', 'en': 'Fraud or Scam', 'ar': 'احتيال'},
    {'key': 'harassment', 'en': 'Harassment', 'ar': 'مضايقة'},
    {'key': 'other', 'en': 'Other', 'ar': 'أخرى'},
  ];

  @override
  void dispose() {
    _additionalDetailsController.dispose();
    super.dispose();
  }

  String _getReasonText(Map<String, String> reason) {
    final localizations = AppLocalizations.of(context)!;
    if (localizations.localeName == 'ar') {
      return reason['ar'] ?? reason['en']!;
    }
    return reason['en']!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaqamiText(
              localizations.reportPost,
              style: RaqamiTextStyles.heading3,
              textColor: theme.colors.foregroundPrimary,
            ),
            const SizedBox(height: 8),
            RaqamiText(
              localizations.reportPostDescription,
              style: RaqamiTextStyles.bodyBaseRegular,
              textColor: theme.colors.foregroundSecondary,
            ),
            const SizedBox(height: 24),
            // Reason selection - Scrollable
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._reportReasons.map((reason) {
                      final reasonKey = reason['key']!;
                      final isSelected = _selectedReason == reasonKey;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedReason = reasonKey;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  color: isSelected ? Colors.black : Colors.white,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RaqamiText(
                                  _getReasonText(reason),
                                  style: RaqamiTextStyles.bodyBaseSemibold,
                                  textColor: const Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    // Additional details - only show when "Other" is selected
                    if (_selectedReason == 'other') ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _additionalDetailsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: localizations.additionalDetails,
                          hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
                            color: theme.colors.foregroundSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.colors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.colors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.colors.tertiary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: RaqamiTextStyles.bodyBaseRegular.copyWith(
                          color: theme.colors.foregroundPrimary,
                        ),
                        onChanged: (value) {
                          setState(() {}); // Trigger rebuild to update button state
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: RaqamiText(
                    localizations.cancel,
                    style: RaqamiTextStyles.bodyBaseSemibold,
                    textColor: theme.colors.foregroundSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedReason == null ||
                          (_selectedReason == 'other' &&
                              _additionalDetailsController.text.trim().isEmpty)
                      ? null
                      : () {
                          widget.onReport(
                            _selectedReason!,
                            _selectedReason == 'other'
                                ? _additionalDetailsController.text.trim()
                                : null,
                          );
                          Navigator.of(context).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colors.tertiary,
                    foregroundColor: theme.colors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: RaqamiText(
                    localizations.submit,
                    style: RaqamiTextStyles.bodyBaseSemibold,
                    textColor: theme.colors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
