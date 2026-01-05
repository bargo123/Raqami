import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme_data.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
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
          localizations.aboutUs,
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
            // App Logo/Icon Section
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colors.tertiary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.numbers,
                  size: 50,
                  color: theme.colors.tertiary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // App Name
            Center(
              child: RaqamiText(
                localizations.appName,
                style: RaqamiTextStyles.heading1,
                textColor: theme.colors.foregroundPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // App Description
            RaqamiText(
              localizations.aboutUsDescription,
              style: RaqamiTextStyles.bodyBaseRegular,
              textColor: theme.colors.foregroundSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // About Section
            _buildSection(
              context,
              theme,
              localizations.aboutRaqami,
              localizations.aboutRaqamiContent,
            ),
            const SizedBox(height: 24),
            
            // Features Section
            _buildSection(
              context,
              theme,
              localizations.features,
              localizations.featuresContent,
            ),
            const SizedBox(height: 24),
            
            // Contact Section
            _buildSection(
              context,
              theme,
              localizations.aboutUsContactTitle,
              localizations.aboutUsContactContent,
            ),
            const SizedBox(height: 32),
            
            // Version Info
            Center(
              child: RaqamiText(
                _appVersion.isEmpty
                    ? ''
                    : localizations.version(_appVersion),
                style: RaqamiTextStyles.bodySmallRegular,
                textColor: theme.colors.foregroundSecondary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Copyright
            Center(
              child: RaqamiText(
                localizations.copyright,
                style: RaqamiTextStyles.bodySmallRegular,
                textColor: theme.colors.foregroundSecondary,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    RaqamiThemeData theme,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaqamiText(
          title,
          style: RaqamiTextStyles.heading4,
          textColor: theme.colors.foregroundPrimary,
        ),
        const SizedBox(height: 12),
        RaqamiText(
          content,
          style: RaqamiTextStyles.bodyBaseRegular,
          textColor: theme.colors.foregroundSecondary,
        ),
      ],
    );
  }
}

