import 'package:flutter/material.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class RaqamiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final double? height;
  const RaqamiButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.padding,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colors.tertiary, // Base.Black
          foregroundColor: theme.colors.secondary, // Base.White
          disabledBackgroundColor: theme.colors.backgroundDisabled,
          disabledForegroundColor: theme.colors.foregroundDisabled,
          elevation: 5,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colors.secondary,
                  ),
                ),
              )
             : Row(
              children: [
                icon != null ? icon! : const SizedBox.shrink(),
                  Text(
                  text,
                  style: RaqamiTextStyles.bodyBaseSemibold.copyWith(
                    color: theme.colors.secondary,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

