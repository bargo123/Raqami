import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/navigation/arguments/user_arguments.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/profile/widgets/profile_header.dart';
import 'package:raqami/src/presentation/profile/widgets/summary_stats.dart';
import 'package:raqami/src/presentation/profile/widgets/section_header.dart';
import 'package:raqami/src/presentation/profile/widgets/account_item.dart';
import 'package:raqami/src/presentation/profile/widgets/sign_out_button.dart';
import 'package:raqami/src/presentation/profile/widgets/version_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';
import 'package:raqami/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/core/utils/language_preference_manager.dart';
import 'package:raqami/src/presentation/profile/widgets/language_selection_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: RaqamiText(
            AppLocalizations.of(context)!.profile,
            style: RaqamiTextStyles.bodyLargeSemibold,
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: theme.colors.backgroundPrimary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Profile Header
                  BlocBuilder<WrapperBloc, WrapperState>(
                    builder: (context, state) {
                      return ProfileHeader(
                        name: state.userData?.name ?? '',
                        email: state.userData?.email ?? '',
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RoutesConstants.editProfile,
                            arguments: UserArguments(
                              fullName: state.userData?.name ?? '',
                              email: state.userData?.email ?? '',
                              phone: state.userData?.phoneNumber ?? '',
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Summary Stats
                  BlocListener<WrapperBloc, WrapperState>(
                    listener: (context, wrapperState) {
                      final userId = wrapperState.userData?.uid ?? '';
                      if (userId.isNotEmpty) {
                        // Load counts when user is available
                        final profileBloc = context.read<ProfileBloc>();
                        profileBloc.add(ProfileEvent.loadMyPostsCount(userId: userId));
                        profileBloc.add(ProfileEvent.loadWishlistCount(userId: userId));
                      }
                    },
                    child: const SummaryStats(),
                  ),
                  const SizedBox(height: 32),
                  // MY ACTIVITY Section

                  // ACCOUNT Section
                  SectionHeader(title: AppLocalizations.of(context)!.account),
                  const SizedBox(height: 16),
                  AccountItem(
                    icon: Assets.images.notificationsIc.svg(),
                    title: AppLocalizations.of(context)!.notifications,
                    onTap: null, // Disabled
                  ),
                  Consumer<LanguagePreferenceManager>(
                    builder: (context, languageManager, child) {
                      return AccountItem(
                        icon: Assets.images.languageIc.svg(),
                        title: AppLocalizations.of(context)!.language,
                        subtitle: LanguagePreferenceManager.getLanguageDisplayName(
                          languageManager.currentLanguage,
                        ),
                        onTap: () {
                          _showLanguageBottomSheet(context, languageManager);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // SUPPORT Section
                  SectionHeader(title: AppLocalizations.of(context)!.support),
                  const SizedBox(height: 16),
                  AccountItem(
                    icon: Icon(
                      Icons.help_outline,
                      size: 24,
                      color: theme.colors.foregroundPrimary,
                    ),
                    title: AppLocalizations.of(context)!.contactUs,
                    onTap: () {
                      Navigator.of(context).pushNamed(RoutesConstants.contactUs);
                    },
                  ),
                  AccountItem(
                    icon: Icon(
                      Icons.info_outline,
                      size: 24,
                      color: theme.colors.foregroundPrimary,
                    ),
                    title: AppLocalizations.of(context)!.aboutUs,
                    onTap: () {
                      Navigator.of(context).pushNamed(RoutesConstants.aboutUs);
                    },
                  ),
                  AccountItem(
                    icon: Icon(
                      Icons.privacy_tip_outlined,
                      size: 24,
                      color: theme.colors.foregroundPrimary,
                    ),
                    title: AppLocalizations.of(context)!.privacyPolicy,
                    onTap: () {
                      Navigator.of(context).pushNamed(RoutesConstants.privacyPolicy);
                    },
                  ),
                  const SizedBox(height: 32),
                  // Sign Out Button
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) async{
                      if (state.isSuccess) {         
                        // await di.reset();
                        // await configureDependencies();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutesConstants.login,
                          (route) => false,
                        );
                      }
                      if (state.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error!),
                            backgroundColor: theme.colors.statusError,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return SignOutButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                context.read<ProfileBloc>().add(
                                  const ProfileEvent.signOut(),
                                );
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Version Text
                  const VersionText(),
                  const SizedBox(height: 170),
                ],
              ),
            ),
          ),
        ),
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    LanguagePreferenceManager languageManager,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguageSelectionBottomSheet(
        currentLanguage: languageManager.currentLanguage,
        onLanguageSelected: (languageCode) async {
          await languageManager.setLanguage(languageCode);
        },
      ),
    );
  }
}
