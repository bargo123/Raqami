import 'package:flutter/material.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';

class PlateFilterWidget extends StatefulWidget {
  final Function({
    UAEEmirate? emirate,
    String? code,
    int? digitCount,
  }) onSearch;

  const PlateFilterWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<PlateFilterWidget> createState() => _PlateFilterWidgetState();
}

class _PlateFilterWidgetState extends State<PlateFilterWidget> {
  UAEEmirate? _selectedEmirate;
  String? _selectedCode;
  int? _selectedDigitCount;
  List<String> _availableCodes = [];

  @override
  void initState() {
    super.initState();
  }

  void _onEmirateChanged(UAEEmirate? emirate) {
    setState(() {
      _selectedEmirate = emirate;
      _selectedCode = null; // Reset code when emirate changes
      _availableCodes = [];
      
      if (emirate != null) {
        // Get valid codes for the selected emirate
        final plateSelection = PlateSelection(
          emirate: emirate,
          plateType: PlateType.standard,
        );
        _availableCodes = plateSelection.validCodes;
      }
    });
  }

  void _onCodeChanged(String? code) {
    setState(() {
      _selectedCode = code;
    });
  }

  void _onDigitCountChanged(int? count) {
    setState(() {
      _selectedDigitCount = count;
    });
  }

  void _onSearch() {
    widget.onSearch(
      emirate: _selectedEmirate,
      code: _selectedCode,
      digitCount: _selectedDigitCount,
    );
  }

  void _onReset() {
    setState(() {
      _selectedEmirate = null;
      _selectedCode = null;
      _selectedDigitCount = null;
      _availableCodes = [];
    });
    widget.onSearch(
      emirate: null,
      code: null,
      digitCount: null,
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
          // First Row: Emirate and Code
          Row(
            children: [
              // Emirate Selector
              Expanded(
                child: _buildCompactDropdown<UAEEmirate>(
                  value: _selectedEmirate,
                  items: UAEEmirate.values,
                  onChanged: _onEmirateChanged,
                  displayText: (emirate) => emirate.name,
                  label: localizations.emirate,
                ),
              ),
              const SizedBox(width: 8),
              // Code Selector (always visible but disabled if no emirate)
              Expanded(
                child: _buildCompactDropdown<String>(
                  value: _selectedCode,
                  items: _availableCodes,
                  onChanged: _selectedEmirate != null && _availableCodes.isNotEmpty
                      ? _onCodeChanged
                      : null,
                  displayText: (code) => code,
                  label: localizations.code,
                  enabled: _selectedEmirate != null && _availableCodes.isNotEmpty,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Second Row: Digit Count, Search and Reset Buttons
          Row(
            children: [
              // Digit Count Selector
              Expanded(
                child: _buildCompactDigitCountSelector(),
              ),
              const SizedBox(width: 8),
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

  Widget _buildCompactDropdown<T>({
    required T? value,
    required List<T> items,
    required Function(T?)? onChanged,
    required String Function(T) displayText,
    required String label,
    bool enabled = true,
  }) {
    final theme = RaqamiTheme.of(context);

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
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          hint: Text(
            label,
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
            DropdownMenuItem<T>(
              value: null,
              child: Text(
                label, // Show label instead of "All"
                style: RaqamiTextStyles.bodySmallRegular.copyWith(
                  color: theme.colors.foregroundSecondary,
                ),
              ),
            ),
            ...items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayText(item),
                  style: RaqamiTextStyles.bodySmallRegular,
                ),
              );
            }),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }

  Widget _buildCompactDigitCountSelector() {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final digitCounts = [1, 2, 3, 4, 5]; // Changed from 1-8 to 1-5

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
        child: DropdownButton<int>(
          value: _selectedDigitCount,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          hint: Text(
            localizations.digitCount,
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
            DropdownMenuItem<int>(
              value: null,
              child: Text(
                localizations.digitCount,
                style: RaqamiTextStyles.bodySmallRegular.copyWith(
                  color: theme.colors.foregroundSecondary,
                ),
              ),
            ),
            ...digitCounts.map((count) {
              return DropdownMenuItem<int>(
                value: count,
                child: Text(
                  '$count',
                  style: RaqamiTextStyles.bodySmallRegular,
                ),
              );
            }),
          ],
          onChanged: _onDigitCountChanged,
        ),
      ),
    );
  }
}

