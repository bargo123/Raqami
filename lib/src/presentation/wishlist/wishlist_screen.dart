import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/widgets/post_card.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';
import 'package:raqami/src/presentation/wishlist/bloc/wishlist_bloc.dart';

class WhislistScreen extends StatefulWidget {
  const WhislistScreen({super.key});

  @override
  State<WhislistScreen> createState() => _WhislistScreenState();
}

class _WhislistScreenState extends State<WhislistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<WrapperBloc, WrapperState>(
      builder: (context, wrapperState) {
        final userId = wrapperState.userData?.uid;

        if (userId == null) {
          return Scaffold(
            backgroundColor: theme.colors.backgroundPrimary,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.colors.backgroundPrimary,
              elevation: 0,
              title: RaqamiText(
                localizations.wishlist,
                style: RaqamiTextStyles.heading3,
                textColor: theme.colors.foregroundPrimary,
              ),
            ),
            body: Center(
              child: RaqamiText(
                localizations.pleaseSignInToViewYourWishlist,
                style: RaqamiTextStyles.bodyBaseRegular,
                textColor: theme.colors.foregroundSecondary,
              ),
            ),
          );
        }

        return Scaffold(
            backgroundColor: theme.colors.backgroundPrimary,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.colors.backgroundPrimary,
              elevation: 0,
              title: RaqamiText(
                localizations.wishlist,
                style: RaqamiTextStyles.heading3,
                textColor: theme.colors.foregroundPrimary,
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: theme.colors.tertiary,
                labelColor: theme.colors.tertiary,
                unselectedLabelColor: theme.colors.foregroundSecondary,
                labelStyle: RaqamiTextStyles.bodyBaseSemibold,
                unselectedLabelStyle: RaqamiTextStyles.bodyBaseRegular,
                tabs: [
                  Tab(text: localizations.phoneNumber),
                  Tab(text: localizations.carPlate),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsList(context, userId, theme, localizations, PostType.phoneNumber),
                _buildPostsList(context, userId, theme, localizations, PostType.carPlate),
              ],
            ),
        );
      },
    );
  }

  Widget _buildPostsList(
    BuildContext context,
    String userId,
    dynamic theme,
    AppLocalizations localizations,
    PostType postType,
  ) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        if (state.isLoading && state.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null && state.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaqamiText(
                  localizations.errorLoadingWishlist(state.error ?? ''),
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.statusError,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<WishlistBloc>().add(
                      WishlistEvent.loadLikedPosts(userId: userId),
                    );
                  },
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        }

        // Filter posts by post type
        final filteredPosts = state.posts.where(
          (post) => post.type == postType,
        ).toList();

        return RefreshIndicator(
          onRefresh: () async {
            context.read<WishlistBloc>().add(
              WishlistEvent.loadLikedPosts(userId: userId),
            );
            await context.read<WishlistBloc>().stream.firstWhere(
              (state) => !state.isLoading,
            );
          },
          child: filteredPosts.isEmpty && !state.isLoading
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.images.unselectedHeart.svg(
                              width: 64,
                              height: 64,
                              colorFilter: ColorFilter.mode(
                                theme.colors.foregroundSecondary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            RaqamiText(
                              localizations.noWishlistPosts,
                              style: RaqamiTextStyles.bodyBaseRegular,
                              textColor: theme.colors.foregroundSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : filteredPosts.isEmpty && state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return Column(
                          children: [
                            PostCard(
                              post: post,
                              userId: userId,
                              onLikeTap: (val) {
                                // Update WishlistBloc
                                context.read<WishlistBloc>().add(
                                  WishlistEvent.likePost(
                                    postId: post.id,
                                    userId: userId,
                                  ),
                                );
                                // Note: HomeBloc will be updated when user navigates back to home
                                return Future.value(val);
                              },
                            ),
                            if (index == filteredPosts.length - 1)
                              const SizedBox(height: 170),
                          ],
                        );
                      },
                    ),
        );
      },
    );
  }
}




