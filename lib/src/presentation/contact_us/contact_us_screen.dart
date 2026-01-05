import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static const String contactEmail = 'raqami2026@outlook.com';

  Future<void> _openEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      query: 'subject=Contact Us - Raqami App',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.couldNotOpenEmail),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _copyEmailToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: contactEmail));
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${localizations.emailCopied}: $contactEmail'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: theme.colors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colors.foregroundPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: RaqamiText(
          localizations.contactUs,
          style: RaqamiTextStyles.heading3,
          textColor: theme.colors.foregroundPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Contact Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colors.tertiary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 50,
                  color: theme.colors.tertiary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Center(
              child: RaqamiText(
                localizations.contactUs,
                style: RaqamiTextStyles.heading2,
                textColor: theme.colors.foregroundPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Center(
              child: RaqamiText(
                localizations.contactUsDescription,
                style: RaqamiTextStyles.bodyBaseRegular,
                textColor: theme.colors.foregroundSecondary,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            
            // Email Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colors.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RaqamiText(
                          localizations.email,
                          style: RaqamiTextStyles.bodySmallRegular,
                          textColor: theme.colors.foregroundSecondary,
                        ),
                        const SizedBox(height: 4),
                        RaqamiText(
                          contactEmail,
                          style: RaqamiTextStyles.bodyLargeSemibold,
                          textColor: theme.colors.foregroundPrimary,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_outlined,
                      color: theme.colors.tertiary,
                    ),
                    onPressed: () => _copyEmailToClipboard(context),
                    tooltip: localizations.copy,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Contact Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openEmail(context),
                icon: const Icon(Icons.email, size: 20),
                label: RaqamiText(
                  localizations.sendEmail,
                  style: RaqamiTextStyles.bodyBaseSemibold,
                  textColor: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colors.tertiary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Additional Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colors.tertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RaqamiText(
                      localizations.contactUsInfo,
                      style: RaqamiTextStyles.bodySmallRegular,
                      textColor: theme.colors.foregroundSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

