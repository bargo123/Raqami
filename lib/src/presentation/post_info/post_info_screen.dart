import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/post_info/bloc/post_info_bloc.dart';
import 'package:raqami/src/presentation/home/widgets/plate_preview_card.dart';
import 'package:raqami/src/presentation/home/widgets/phone_preview_card.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/raqami_like_button.dart';
import 'package:raqami/src/presentation/post_info/widgets/report_post_dialog.dart';

/// Screen displaying post information with poster contact details
class PostInfoScreen extends StatelessWidget {
  final String userId;

  const PostInfoScreen({
    super.key,
    required this.userId,
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

  Future<void> _openWhatsApp(BuildContext context, String phoneNumber) async {
    try {
      // Remove any non-digit characters
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      // Ensure the number has country code (add 971 for UAE if not present)
      final formattedNumber = cleanNumber.startsWith('971') 
          ? cleanNumber 
          : '971$cleanNumber';
      
      final url = Uri.parse('https://wa.me/$formattedNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.couldNotOpenWhatsApp)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    try {
      // Remove any non-digit characters except +
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final url = Uri.parse('tel:$cleanNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.couldNotMakePhoneCall)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _sharePost(BuildContext context, PostModel post) async {
        final localizations = AppLocalizations.of(context)!;

    try {
      final formatter = NumberFormat('#,###');
      final priceText = post.price > 0
          ? '${formatter.format(post.price)} ${post.currency}'
          : localizations.priceHidden;
      
      final shareText = '${post.type == PostType.carPlate ? 'Car Plate' : 'Phone Number'}: ${post.number}\n'
          'Price: $priceText\n'
          'Contact: ${post.creatorName}';
      
      await Share.share(shareText);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: ${e.toString()}')),
        );
      }
    }
  }

  void _showReportDialog(BuildContext context, PostModel post) {
    showDialog(
      context: context,
      builder: (dialogContext) => ReportPostDialog(
        onReport: (reason, additionalDetails) {
          context.read<PostInfoBloc>().add(
            PostInfoEvent.reportPost(
              postId: post.id,
              reporterId: userId,
              reason: reason,
              additionalDetails: additionalDetails,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final formatter = NumberFormat('#,###');

    return BlocConsumer<PostInfoBloc, PostInfoState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.reportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.reportSubmitted),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final post = state.post;
        final isLiked = post.likedBy.contains(userId);

        return Scaffold(
          backgroundColor: theme.colors.backgroundPrimary,
          appBar: AppBar(
            backgroundColor: theme.colors.backgroundPrimary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colors.foregroundPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: RaqamiText(
              localizations.postInformation,
              style: RaqamiTextStyles.heading3,
              textColor: theme.colors.foregroundPrimary,
            ),
            actions: [
              RaqamiLikeButton(
                      isLiked: isLiked,
                      onTap: (bool currentIsLiked) async {
                        context.read<PostInfoBloc>().add(
                          PostInfoEvent.likePost(userId: userId),
                        );
                        return !currentIsLiked;
                      },
                      padding: const EdgeInsets.all(8),
                    ),
              IconButton(
                icon: Assets.images.share.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    theme.colors.foregroundPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => _sharePost(context, post),
              ),
              IconButton(
                icon: Icon(
                  Icons.flag_outlined,
                  color: theme.colors.foregroundPrimary,
                ),
                onPressed: () => _showReportDialog(context, post),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Post Card Section
                Container(
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
                          // Price - closer to preview for phone numbers and plates
                          SizedBox(height: (post.type == PostType.phoneNumber || post.type == PostType.carPlate) ? 8 : 12),
                          RaqamiText(
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
                          const SizedBox(height: 4),
                          // Posted date
                          RaqamiText(
                            '${localizations.posted}: ${_formatDate(context, post.createdAt)}',
                            style: RaqamiTextStyles.bodySmallRegular,
                            textColor: theme.colors.foregroundSecondary,
                          ),
                          // Description if available
                          if (post.description != null && post.description!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            RaqamiText(
                              post.description!,
                              style: RaqamiTextStyles.bodyBaseRegular,
                              textColor: theme.colors.foregroundPrimary,
                            ),
                          ],
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
                const SizedBox(height: 24),
                // Poster Contact Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RaqamiText(
                        localizations.contactPoster,
                        style: RaqamiTextStyles.heading4,
                        textColor: theme.colors.foregroundPrimary,
                      ),
                      const SizedBox(height: 12),
                      RaqamiText(
                        post.creatorName,
                        style: RaqamiTextStyles.bodyLargeSemibold,
                        textColor: theme.colors.foregroundPrimary,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _openWhatsApp(context, post.creatorPhoneNumber),
                              icon: const Icon(Icons.chat, size: 20),
                              label: Text(localizations.whatsApp),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366), // WhatsApp green
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _makePhoneCall(context, post.creatorPhoneNumber),
                              icon: const Icon(Icons.phone, size: 20),
                              label: Text(localizations.call),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colors.tertiary,
                                foregroundColor: theme.colors.secondary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
