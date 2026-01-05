import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class BottomNavbarItems extends StatelessWidget {
  const BottomNavbarItems({
    super.key,
    this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
    this.isSelected = false,
    this.selectedColor,
    this.unselectedColor,
  });

  final String? label;
  final Widget selectedIcon;
  final Widget unselectedIcon;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          isSelected ? selectedIcon : unselectedIcon,
          if (label != null)
            FittedBox(
              child: RaqamiText(
                label!,
                style: RaqamiTextStyles.bodySmallRegular,
                textColor: isSelected
                    ? (selectedColor ?? theme.colors.foregroundPrimary)
                    : (unselectedColor ?? theme.colors.foregroundSecondary),
              ),
            ),
        ],
      ),
    );
  }

  BottomNavbarItems copyWith({
    Key? key,
    String? label,
    Widget? selectedIcon,
    Widget? unselectedIcon,
    bool? isSelected,
    Color? selectedColor,
    Color? unselectedColor,
  }) {
    return BottomNavbarItems(
      key: key ?? this.key,
      label: label ?? this.label,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      unselectedIcon: unselectedIcon ?? this.unselectedIcon,
      isSelected: isSelected ?? this.isSelected,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
    );
  }
}

