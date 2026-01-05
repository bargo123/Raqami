import 'dart:ui';
import 'package:flutter/material.dart';


class RaqamiColors {
  // Neutral Colors
  final Color neutral50;
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral900;
  final Color neutral950;

  // Beige Colors
  final Color beige50;
  final Color beige100;
  final Color beige200;
  final Color beige300;
  final Color beige400;
  final Color beige500;
  final Color beige600;
  final Color beige700;
  final Color beige800;
  final Color beige900;
  final Color beige950;

  // Leaf Colors
  final Color leaf50;
  final Color leaf100;
  final Color leaf200;
  final Color leaf300;
  final Color leaf400;
  final Color leaf500;
  final Color leaf600;
  final Color leaf700;
  final Color leaf800;
  final Color leaf900;
  final Color leaf950;

  // Egg Colors
  final Color egg50;
  final Color egg100;
  final Color egg200;
  final Color egg300;
  final Color egg400;
  final Color egg500;
  final Color egg600;
  final Color egg700;
  final Color egg800;
  final Color egg900;
  final Color egg950;

  // Crimson Colors
  final Color crimson50;
  final Color crimson100;
  final Color crimson200;
  final Color crimson300;
  final Color crimson400;
  final Color crimson500;
  final Color crimson600;
  final Color crimson700;
  final Color crimson800;
  final Color crimson900;
  final Color crimson950;

  // Blue Colors
  final Color blue50;
  final Color blue100;
  final Color blue200;
  final Color blue300;
  final Color blue400;
  final Color blue500;
  final Color blue600;
  final Color blue700;
  final Color blue800;
  final Color blue900;
  final Color blue950;

  // Green Colors
  final Color green50;
  final Color green100;
  final Color green200;
  final Color green300;
  final Color green400;
  final Color green500;
  final Color green600;
  final Color green700;
  final Color green800;
  final Color green900;
  final Color green950;

  // State Colors
  final Color statusWarning;
  final Color statusInfo;
  final Color statusError;
  final Color statusSuccess;

  // Base Colors
  final Color baseWhite;
  final Color baseBlack;

  // Tokens/Light/base
  final Color surface;
  final Color foregroundPrimary;
  final Color foregroundDisabled;
  final Color divider;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color card;
  final Color primary;
  final Color secondary;
  final Color border;
  final Color foregroundSecondary;
  final Color backgroundDisabled;
  final Color foreground;
  final Color accent;
  final Color tertiary;
  final Color primitive;
  final Color backgroundTertiary;
  final Color border2;
  final Color towhite;

  // Legacy Semantic Colors (deprecated - use token names above)
  @Deprecated('Use foregroundPrimary instead')
  final Color baseForegroundPrimary;
  @Deprecated('Use foregroundSecondary instead')
  final Color baseForegroundSecondary;
  @Deprecated('Use divider instead')
  final Color baseDivider;
  @Deprecated('Use foregroundPrimary instead')
  final Color textColor;

  const RaqamiColors({
    // Neutral Colors
    this.neutral50 = const Color(0xFFFAFAFA),
    this.neutral100 = const Color(0xFFF5F5F5),
    this.neutral200 = const Color(0xFFE5E5E5),
    this.neutral300 = const Color(0xFFD4D4D4),
    this.neutral400 = const Color(0xFFA3A3A3),
    this.neutral500 = const Color(0xFF737373),
    this.neutral600 = const Color(0xFF525252),
    this.neutral700 = const Color(0xFF404040),
    this.neutral800 = const Color(0xFF262626),
    this.neutral900 = const Color(0xFF171717),
    this.neutral950 = const Color(0xFF0A0A0A),
    
    // Beige Colors
    this.beige50 = const Color(0xFFFAF6F4),
    this.beige100 = const Color(0xFFF1EBE3),
    this.beige200 = const Color(0xFFE9DFD4),
    this.beige300 = const Color(0xFFCEBAA3),
    this.beige400 = const Color(0xFFB99A7E),
    this.beige500 = const Color(0xFFAB8264),
    this.beige600 = const Color(0xFF9E7159),
    this.beige700 = const Color(0xFF835C4B),
    this.beige800 = const Color(0xFF6C4D41),
    this.beige900 = const Color(0xFF583F38),
    this.beige950 = const Color(0xFF2E201C),
    
    // Leaf Colors
    this.leaf50 = const Color(0xFFF8FEE6),
    this.leaf100 = const Color(0xFFE9FDCB),
    this.leaf200 = const Color(0xFFD9FA9B),
    this.leaf300 = const Color(0xFFBAF463),
    this.leaf400 = const Color(0xFFA1E633),
    this.leaf500 = const Color(0xFF82CC15),
    this.leaf600 = const Color(0xFF62A40F),
    this.leaf700 = const Color(0xFF4A7D0F),
    this.leaf800 = const Color(0xFF446C13),
    this.leaf900 = const Color(0xFF365313),
    this.leaf950 = const Color(0xFF1A2F04),
    
    // Egg Colors
    this.egg50 = const Color(0xFFFFF7ED),
    this.egg100 = const Color(0xFFFEEBCF),
    this.egg200 = const Color(0xFFFCD9AD),
    this.egg300 = const Color(0xFFFABD77),
    this.egg400 = const Color(0xFFF79640),
    this.egg500 = const Color(0xFFED8423),
    this.egg600 = const Color(0xFFDF6C18),
    this.egg700 = const Color(0xFFB95115),
    this.egg800 = const Color(0xFF934119),
    this.egg900 = const Color(0xFF763818),
    this.egg950 = const Color(0xFF401A0A),
    
    // Crimson Colors
    this.crimson50 = const Color(0xFFFEF1F0),
    this.crimson100 = const Color(0xFFFFE3E4),
    this.crimson200 = const Color(0xFFFFCBCE),
    this.crimson300 = const Color(0xFFFFA0A8),
    this.crimson400 = const Color(0xFFFF6A78),
    this.crimson500 = const Color(0xFFFD364D),
    this.crimson600 = const Color(0xFFD91133),
    this.crimson700 = const Color(0xFFC7082E),
    this.crimson800 = const Color(0xFFA60B2E),
    this.crimson900 = const Color(0xFF8E0D2E),
    this.crimson950 = const Color(0xFF4F0113),
    
    // Blue Colors
    this.blue50 = const Color(0xFFEDFBFD),
    this.blue100 = const Color(0xFFD2F3FB),
    this.blue200 = const Color(0xFFACE7F6),
    this.blue300 = const Color(0xFF71D5EF),
    this.blue400 = const Color(0xFF2FB9E0),
    this.blue500 = const Color(0xFF1396BE),
    this.blue600 = const Color(0xFF157DA7),
    this.blue700 = const Color(0xFF196487),
    this.blue800 = const Color(0xFF1C546E),
    this.blue900 = const Color(0xFF1C465E),
    this.blue950 = const Color(0xFF0C2C40),
    
    // Green Colors
    this.green50 = const Color(0xFFF0F9F5),
    this.green100 = const Color(0xFFDAF1E4),
    this.green200 = const Color(0xFFB7E2CE),
    this.green300 = const Color(0xFF89CCAF),
    this.green400 = const Color(0xFF5AB18F),
    this.green500 = const Color(0xFF369372),
    this.green600 = const Color(0xFF24765B),
    this.green700 = const Color(0xFF1E5E4A),
    this.green800 = const Color(0xFF1A4B3C),
    this.green900 = const Color(0xFF163E32),
    this.green950 = const Color(0xFF0B231C),
    
    // State Colors (from Tokens/Light/status)
    this.statusWarning = const Color(0xFFFCD9AD), // Egg.200
    this.statusInfo = const Color(0xFFA3A3A3), // Neutral.400
    this.statusError = const Color(0xFFFD364D), // Crimson.500
    this.statusSuccess = const Color(0xFF369372), // Green.500
    
    // Base Colors
    this.baseWhite = const Color(0xFFFFFFFF),
    this.baseBlack = const Color(0xFF1E1F20),
    
    // Tokens/Light/base
    this.surface = const Color(0xFFFFFFFF), // Colors.Base.White
    this.foregroundPrimary = const Color(0xFF0A0A0A), // Colors.Neutral.950
    this.foregroundDisabled = const Color(0xFFA3A3A3), // Colors.Neutral.400
    this.divider = const Color(0xFFE5E5E5), // Colors.Neutral.200
    this.backgroundPrimary = const Color(0xFFFFFFFF), // Colors.Base.White
    this.backgroundSecondary = const Color(0xFFFAFAFA), // Colors.Neutral.50
    this.card = const Color(0xFFFFFFFF), // Colors.Base.White
    this.primary = const Color(0xFF262626), // Colors.Neutral.800
    this.secondary = const Color(0xFFFFFFFF), // Colors.Base.White
    this.border = const Color(0xFFE5E5E5), // Colors.Neutral.200
    this.foregroundSecondary = const Color(0xFF737373), // Colors.Neutral.500
    this.backgroundDisabled = const Color(0xFFE5E5E5), // Colors.Neutral.200
    this.foreground = const Color(0xFF262626), // base.primary (Neutral.800)
    this.accent = const Color(0xFFF5F5F5), // Colors.Neutral.100
    this.tertiary = const Color(0xFF1E1F20), // Colors.Base.Black
    this.primitive = const Color(0xCC171717), // #171717cc
    this.backgroundTertiary = const Color(0xFFFAF6F4), // Colors.Beige.50
    this.border2 = const Color(0xFFF5F5F5), // Colors.Neutral.100
    this.towhite = const Color(0xFFFFFFFF), // base.secondary (Base.White)
    
    // Legacy Semantic Colors (deprecated - use token names above)
    this.baseForegroundPrimary = const Color(0xFF0A0A0A), // Neutral.950
    this.baseForegroundSecondary = const Color(0xFF737373), // Neutral.500
    this.baseDivider = const Color(0xFFE5E5E5), // Neutral.200
    this.textColor = const Color(0xFF0A0A0A), // Use foregroundPrimary
  });
}
