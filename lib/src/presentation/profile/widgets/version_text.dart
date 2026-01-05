import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class VersionText extends StatefulWidget {
  const VersionText({super.key});

  @override
  State<VersionText> createState() => _VersionTextState();
}

class _VersionTextState extends State<VersionText> {
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
    return Center(
      child: RaqamiText(
        _appVersion.isEmpty
            ? ''
            : localizations.raqamiVersion(_appVersion),
        style: RaqamiTextStyles.bodySmallRegular,
        textColor: theme.colors.foregroundSecondary,
      ),
    );
  }
}



