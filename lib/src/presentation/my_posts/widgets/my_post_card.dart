import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/home/widgets/plate_preview_card.dart';
import 'package:raqami/src/presentation/home/widgets/phone_preview_card.dart';
import 'package:raqami/src/presentation/my_posts/bloc/my_posts_bloc.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/ui/components/delete_confirmation_dialog.dart';
import 'package:raqami/src/presentation/ui/components/neumorphic_toggle.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

/// Post card widget for displaying user's own posts with sold toggle
class MyPostCard extends StatelessWidget {
  final PostModel post;
  final Function(bool) onSoldToggle;
  final VoidCallback? onPostUpdated;

  const MyPostCard({
    super.key,
    required this.post,
    required this.onSoldToggle,
    this.onPostUpdated,
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
    final formatter = NumberFormat('#,###');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 15,top: 5),
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
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: theme.colors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colors.border),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final result = await Navigator.of(context)
                            .pushNamed(
                              RoutesConstants.postDetail,
                              arguments: post,
                            )
                            .then((value) => value as bool? ?? false);
                        // If post was deleted or updated, refresh the list
                        if (result == true && onPostUpdated != null) {
                          onPostUpdated!();
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  BlocBuilder<MyPostsBloc, MyPostsState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          _showDeleteConfirmation(context);
                        },
                        icon: Assets.images.deleteItemIc.svg(),
                      );
                    },
                  ),
                ],
              ),
              // Plate or Phone Preview
              if (post.type == PostType.carPlate && post.emirate != null)
                Center(child: PlatePreviewCard(post: post))
              else if (post.type == PostType.phoneNumber)
                Center(child: PhonePreviewCard(post: post))
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
              // Price and Likes Row - closer to preview for phone numbers and plates
              SizedBox(height: (post.type == PostType.phoneNumber || post.type == PostType.carPlate) ? 8 : 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RaqamiText(
                          post.price > 0
                              ? '${formatter.format(post.price)} ${post.currency}'
                              : AppLocalizations.of(context)!.priceHidden,
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: theme.colors.tertiary,
                            ),
                            const SizedBox(width: 4),
                            RaqamiText(
                              '${post.likedBy.length}',
                              style: RaqamiTextStyles.bodySmallRegular,
                              textColor: theme.colors.foregroundSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Sold Toggle
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RaqamiText(
                        AppLocalizations.of(context)!.markAsSold,
                        style: RaqamiTextStyles.bodySmallRegular,
                        textColor: theme.colors.foregroundSecondary,
                      ),
                      const SizedBox(height: 4),
                      NeumorphicToggle(
                        value: post.sold,
                        onChanged: onSoldToggle,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Posted date
              RaqamiText(
                '${AppLocalizations.of(context)!.posted}: ${_formatDate(context, post.createdAt)}',
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
                    AppLocalizations.of(context)!.sold,
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
    );
  }

  void _showDeleteConfirmation(BuildContext stateContext) {
    DeleteConfirmationDialog.showDeletePost(
      context: stateContext,
      onConfirm: () {
        stateContext.read<MyPostsBloc>().add(
          MyPostsEvent.deletePost(postId: post.id),
        );
      },
    );
  }
}
