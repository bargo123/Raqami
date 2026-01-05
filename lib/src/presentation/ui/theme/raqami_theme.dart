import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme_data.dart';

class RaqamiTheme extends InheritedWidget {
  final RaqamiThemeData data;

  const RaqamiTheme({super.key, required this.data, required super.child});

  static RaqamiThemeData of(BuildContext context) {
    final RaqamiTheme? inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<RaqamiTheme>();
    assert(inheritedTheme != null, 'No thme found in context');
    return inheritedTheme!.data;
  }

  @override
  bool updateShouldNotify(covariant RaqamiTheme oldWidget) {
    return data != oldWidget.data;
  }
}
