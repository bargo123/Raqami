import 'package:flutter/material.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';

class PhoneFilterWidget extends StatefulWidget {
  final Function({
    PhoneProvider? provider,
    String? code,
  }) onSearch;

  const PhoneFilterWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<PhoneFilterWidget> createState() => _PhoneFilterWidgetState();
}

class _PhoneFilterWidgetState extends State<PhoneFilterWidget> {
  PhoneProvider? _selectedProvider;
  String? _selectedCode;
  List<String> _availableCodes = [];

  @override
  void initState() {
    super.initState();
  }

  void _onProviderChanged(PhoneProvider? provider) {
    setState(() {
      _selectedProvider = provider;
      _selectedCode = null; // Reset code when provider changes
      _availableCodes = [];
      
      if (provider != null) {
        // Get valid codes for the selected provider
        _availableCodes = provider.validCodes;
      }
    });
  }

  void _onCodeChanged(String? code) {
    setState(() {
      _selectedCode = code;
    });
  }

  void _onSearch() {
    widget.onSearch(
      provider: _selectedProvider,
      code: _selectedCode,
    );
  }

  void _onReset() {
    setState(() {
      _selectedProvider = null;
      _selectedCode = null;
      _availableCodes = [];
    });
    widget.onSearch(
      provider: null,
      code: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colors.backgroundSecondary,
        border: Border(
          bottom: BorderSide(
            color: theme.colors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First Row: Provider and Code
          Row(
            children: [
              // Provider Selector
              Expanded(
                child: _buildProviderDropdown(),
              ),
              const SizedBox(width: 8),
              // Code Selector
              Expanded(
                child: _buildCodeDropdown(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Second Row: Search and Reset Buttons
          Row(
            children: [
              const Spacer(),
              // Search Button
              SizedBox(
                height: 40,
                child: RaqamiButton(
                  text: localizations.search,
                  onPressed: _onSearch,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const SizedBox(width: 8),
              // Reset Button
              SizedBox(
                height: 40,
                child: RaqamiButton(
                  text: localizations.reset,
                  onPressed: _onReset,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProviderDropdown() {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colors.backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colors.border,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PhoneProvider>(
          value: _selectedProvider,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          hint: Text(
            localizations.provider,
            style: RaqamiTextStyles.bodySmallRegular.copyWith(
              color: theme.colors.foregroundSecondary,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colors.foregroundSecondary,
            size: 18,
          ),
          style: RaqamiTextStyles.bodySmallRegular.copyWith(
            color: theme.colors.foregroundPrimary,
          ),
          dropdownColor: theme.colors.backgroundPrimary,
          items: [
            DropdownMenuItem<PhoneProvider>(
              value: null,
              child: Text(
                localizations.provider,
                style: RaqamiTextStyles.bodySmallRegular.copyWith(
                  color: theme.colors.foregroundSecondary,
                ),
              ),
            ),
            ...PhoneProvider.values.map((provider) {
              return DropdownMenuItem<PhoneProvider>(
                value: provider,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: switch (provider) {
                        PhoneProvider.du => Assets.images.duIc.image(
                            fit: BoxFit.contain,
                          ),
                        PhoneProvider.etisalat => Assets.images.etsIc.image(
                            fit: BoxFit.contain,
                          ),
                        PhoneProvider.virgin => Assets.images.virginIc.image(
                            fit: BoxFit.cover,
                          ),
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      provider.displayName,
                      style: RaqamiTextStyles.bodySmallRegular,
                    ),
                  ],
                ),
              );
            }),
          ],
          onChanged: _onProviderChanged,
        ),
      ),
    );
  }

  Widget _buildCodeDropdown() {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final enabled = _selectedProvider != null && _availableCodes.isNotEmpty;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: enabled
            ? theme.colors.backgroundPrimary
            : theme.colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colors.border,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCode,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          hint: Text(
            localizations.code,
            style: RaqamiTextStyles.bodySmallRegular.copyWith(
              color: theme.colors.foregroundSecondary,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: enabled
                ? theme.colors.foregroundSecondary
                : theme.colors.foregroundDisabled,
            size: 18,
          ),
          style: RaqamiTextStyles.bodySmallRegular.copyWith(
            color: enabled
                ? theme.colors.foregroundPrimary
                : theme.colors.foregroundDisabled,
          ),
          dropdownColor: theme.colors.backgroundPrimary,
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                localizations.code,
                style: RaqamiTextStyles.bodySmallRegular.copyWith(
                  color: theme.colors.foregroundSecondary,
                ),
              ),
            ),
            ..._availableCodes.map((code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Text(
                  code,
                  style: RaqamiTextStyles.bodySmallRegular,
                ),
              );
            }),
          ],
          onChanged: enabled ? _onCodeChanged : null,
        ),
      ),
    );
  }
}

