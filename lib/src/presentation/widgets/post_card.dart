import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/home/widgets/plate_preview_card.dart';
import 'package:raqami/src/presentation/home/widgets/phone_preview_card.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/raqami_like_button.dart';

/// Reusable post card widget for displaying posts in home and wishlist screens
class PostCard extends StatelessWidget {
  final PostModel post;
  final String userId;
  final Future<bool> Function(bool) onLikeTap;

  const PostCard({
    super.key,
    required this.post,
    required this.userId,
    required this.onLikeTap,
  });

  String _formatDate(BuildContext context, DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return localizations.today;
    } else if (difference.inDays == 1) {
      return localizations.yesterday;
    } else if (difference.inDays < 7) {
      return localizations.daysAgo(difference.inDays);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final formatter = NumberFormat('#,###');

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          RoutesConstants.postInfo,
          arguments: {
            'post': post,
            'userId': userId,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: post.sold ? Colors.red : theme.colors.border,
            width: post.sold ? 2 : 1,
          ),
        ),
        child: Stack(
        children: [
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plate or Phone Preview
          if (post.type == PostType.carPlate && post.emirate != null)
            Center(
              child: PlatePreviewCard(post: post),
            )
          else if (post.type == PostType.phoneNumber)
            Center(
              child: PhonePreviewCard(post: post),
            )
          else
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colors.neutral100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colors.border),
              ),
              child: Center(
                child: RaqamiText(
                  post.number,
                  style: RaqamiTextStyles.heading3,
                  textColor: theme.colors.foregroundPrimary,
                ),
              ),
            ),
          // Price and Heart Row - closer to preview for phone numbers and plates
          SizedBox(height: (post.type == PostType.phoneNumber || post.type == PostType.carPlate) ? 8 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RaqamiText(
                  post.price > 0
                      ? '${formatter.format(post.price)} ${post.currency}'
                      : localizations.priceHidden,
                  style: (post.type == PostType.phoneNumber || post.type == PostType.carPlate)
                      ? RaqamiTextStyles.heading3.copyWith(
                          fontWeight: FontWeight.bold,
                          color: post.price > 0
                              ? theme.colors.tertiary
                              : theme.colors.foregroundSecondary,
                        )
                      : RaqamiTextStyles.bodyLargeSemibold.copyWith(
                          color: post.price > 0
                              ? theme.colors.tertiary
                              : theme.colors.foregroundSecondary,
                        ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {}, // Absorb tap events to prevent navigation
                child: RaqamiLikeButton(
                  isLiked: post.likedBy.contains(userId),
                  onTap: onLikeTap,
                  likeCount: post.likedBy.length,
                  showCount: true,
                  padding: const EdgeInsets.all(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Posted date
          RaqamiText(
            '${localizations.posted}: ${_formatDate(context, post.createdAt)}',
            style: RaqamiTextStyles.bodySmallRegular,
            textColor: theme.colors.foregroundSecondary,
          ),
            ],
          ),
          // Big SOLD text overlay in center at diagonal angle
          if (post.sold)
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: -0.785398, // -45 degrees in radians
                  child: Text(
                    localizations.sold,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.3),
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}


