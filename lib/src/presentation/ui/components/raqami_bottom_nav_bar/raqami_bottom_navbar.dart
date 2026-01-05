import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/components/raqami_bottom_nav_bar/bottom_navbar.dart';
import 'package:raqami/src/presentation/ui/components/raqami_bottom_nav_bar/bottom_navbar_items.dart';
import 'package:raqami/src/presentation/ui/components/raqami_bottom_nav_bar/raqami_bottom_navbar_items.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';

class RaqamiBottomNavbar extends StatelessWidget {
  const RaqamiBottomNavbar({
    super.key,
    required this.navItems,
    this.selectedIndex = 0,
    this.onNavBarCallBack,
  });
  final List<RaqamiBottomNavBarItems> navItems;
  final int selectedIndex;
  final void Function(int)? onNavBarCallBack;

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: theme.colors.border2),
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BottomNavbar(
        onNavBarCallBack: onNavBarCallBack,
        initialIndex: selectedIndex,
        navItems: navItems
            .map(
              (e) => BottomNavbarItems(
                label: e.title,
                selectedIcon: e.selectedIcon,
                unselectedIcon: e.unselectedIcon,
                isSelected: false,
              ),
            )
            .toList(),
      ),
    );
  }
}

