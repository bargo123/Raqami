import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

/// Widget for displaying phone number preview in landscape phone style
/// Shows provider logo and phone number
class PhonePreview extends StatelessWidget {
  final PostModel? post;
  final String? phoneNumber;
  final PhoneProvider? phoneProvider;
  final bool showContainer;
  final Size? size;

  /// Constructor for PostModel (used in home list, wishlist, my posts)
  const PhonePreview.fromPost({
    super.key,
    required this.post,
    this.showContainer = false,
    this.size,
  })  : phoneNumber = null,
        phoneProvider = null;

  /// Constructor for individual parameters (used in create post)
  const PhonePreview({
    super.key,
    this.post,
    this.phoneNumber,
    this.phoneProvider,
    this.showContainer = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // If using PostModel
    if (post != null) {
      return Directionality(textDirection: TextDirection.ltr, child: _buildFromPost(context));
    }

    // If using individual parameters
    return Directionality(textDirection: TextDirection.ltr, child: _buildFromParameters(context));
  }

  Widget _buildFromPost(BuildContext context) {
    final postNumber = post!.number;
    final postProvider = post!.phoneProvider ?? PhoneProvider.du;
    
    // Format phone number to ensure space between code and number
    // Handle both old format (no space) and new format (with space)
    final formattedNumber = _formatPhoneNumber(postNumber);

    return _buildPhoneWidget(
      context: context,
      phoneNumber: formattedNumber,
      phoneProvider: postProvider,
    );
  }
  
  String _formatPhoneNumber(String number) {
    // If number already has a space, return as is
    if (number.contains(' ')) {
      return number;
    }
    
    // Try to detect code pattern (05x, 050, 052, etc.) and add space after it
    // UAE phone codes are typically 3 digits starting with 05
    final codePattern = RegExp(r'^(05[0-9xX])(\d{7})$');
    final match = codePattern.firstMatch(number);
    if (match != null) {
      return '${match.group(1)} ${match.group(2)}';
    }
    
    // If no pattern matches, return as is
    return number;
  }

  Widget _buildFromParameters(BuildContext context) {
    final displayNumber = phoneNumber ?? '';
    final displayProvider = phoneProvider ?? PhoneProvider.du;

    return _buildPhoneWidget(
      context: context,
      phoneNumber: displayNumber,
      phoneProvider: displayProvider,
    );
  }

  Widget _buildPhoneWidget({
    required BuildContext context,
    required String phoneNumber,
    required PhoneProvider phoneProvider,
  }) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final phoneSize = size ?? const Size(320, 110);

    // Phone body in landscape mode
    final phoneWidget = GestureDetector(
      onLongPress: () {
        // Copy to clipboard on long press
        Clipboard.setData(ClipboardData(text: phoneNumber));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Phone number copied'),
            duration: const Duration(seconds: 1),
            backgroundColor: theme.colors.statusSuccess,
          ),
        );
      },
      child: Container(
        width: phoneSize.width,
        height: phoneSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[850]!,
              Colors.grey[900]!,
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey[700]!,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label row with phone icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      localizations?.phoneNumber ?? 'Phone Number',
                      style: RaqamiTextStyles.bodySmallRegular.copyWith(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Main content row
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Provider Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: _buildProviderLogo(phoneProvider),
                    ),
                    const SizedBox(width: 12),
                    // Phone Number
                    Expanded(
                      child: Text(
                        phoneNumber,
                        style: RaqamiTextStyles.heading1.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.8,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (showContainer) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colors.neutral100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colors.border),
        ),
        padding: const EdgeInsets.all(8),
        child: Center(child: phoneWidget),
      );
    }

    return phoneWidget;
  }

  Widget _buildProviderLogo(PhoneProvider provider) {
    return switch (provider) {
      PhoneProvider.du => Assets.images.duIc.image(
          fit: BoxFit.contain,
        ),
      PhoneProvider.etisalat => Assets.images.etsIc.image(
          fit: BoxFit.contain,
        ),
      PhoneProvider.virgin => Assets.images.virginIc.image(
          fit: BoxFit.cover,
        ),
    };
  }
}

