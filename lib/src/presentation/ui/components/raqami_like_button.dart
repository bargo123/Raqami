import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

/// Shared like button widget used throughout the app
class RaqamiLikeButton extends StatelessWidget {
  /// Whether the post is currently liked
  final bool isLiked;
  
  /// Callback when the like button is tapped
  /// Returns a Future[bool] indicating the new like state
  final Future<bool> Function(bool) onTap;
  
  /// Optional like count to display below the button
  final int? likeCount;
  
  /// Size of the like icon (default: 24)
  final double iconSize;
  
  /// Whether to show the like count below the button
  final bool showCount;
  
  /// Optional custom padding around the button
  final EdgeInsets? padding;

  const RaqamiLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.likeCount,
    this.iconSize = 24,
    this.showCount = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    final likeButton = LikeButton(
      onTap: onTap,
      isLiked: isLiked,
      size: iconSize,
      likeBuilder: (bool isLiked) {
        return AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: isLiked ? Assets.images.selectedHeart.svg() : Assets.images.unselectedHeart.svg(
          width: iconSize,
          height: iconSize,
        
        ));
      },
    );

    if (showCount && likeCount != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: padding ?? EdgeInsets.zero,
            child: likeButton,
          ),
          const SizedBox(height: 4),
          RaqamiText(
            '$likeCount',
            style: RaqamiTextStyles.bodySmallRegular,
            textColor: theme.colors.foregroundSecondary,
          ),
        ],
      );
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: likeButton,
    );
  }
}

/// Simple like button without the like_button package animation
/// Used in places where we need manual state management
class RaqamiSimpleLikeButton extends StatelessWidget {
  /// Whether the post is currently liked
  final bool isLiked;
  
  /// Callback when the like button is tapped
  final VoidCallback onTap;
  
  /// Size of the like icon (default: 24)
  final double iconSize;
  
  /// Optional custom padding around the button
  final EdgeInsets? padding;
  
  /// Optional background decoration
  final BoxDecoration? decoration;

  const RaqamiSimpleLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.iconSize = 24,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    
    final icon = Assets.images.likeIc.svg(
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(
        isLiked ? theme.colors.tertiary : theme.colors.foregroundSecondary,
        BlendMode.srcIn,
      ),
    );

    Widget button = GestureDetector(
      onTap: onTap,
      child: icon,
    );

    if (decoration != null) {
      button = Container(
        padding: padding ?? const EdgeInsets.all(8),
        decoration: decoration,
        child: button,
      );
    } else if (padding != null) {
      button = Padding(
        padding: padding!,
        child: button,
      );
    }

    return button;
  }
}

