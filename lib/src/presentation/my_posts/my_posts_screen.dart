import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/my_posts/bloc/my_posts_bloc.dart';
import 'package:raqami/src/presentation/my_posts/widgets/my_post_card.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> with SingleTickerProviderStateMixin {
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
        final userId = wrapperState.userData?.uid ?? '';

        if (userId.isEmpty) {
          return Scaffold(
            backgroundColor: theme.colors.backgroundPrimary,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.colors.backgroundPrimary,
              elevation: 0,
              title: RaqamiText(
                localizations.myPosts,
                style: RaqamiTextStyles.heading3,
                textColor: theme.colors.foregroundPrimary,
              ),
            ),
            body: Center(
              child: RaqamiText(
                localizations.pleaseLogInToViewYourPosts,
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
                localizations.myPosts,
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
            body: BlocListener<MyPostsBloc, MyPostsState>(
              listener: (context, state) {
                if (state.deleteSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.postDeletedSuccessfully),
                      backgroundColor: theme.colors.statusSuccess,
                    ),
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostsList(context, userId, theme, localizations, PostType.phoneNumber),
                  _buildPostsList(context, userId, theme, localizations, PostType.carPlate),
                ],
              ),
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
    return BlocBuilder<MyPostsBloc, MyPostsState>(
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
                  localizations.errorLoadingPosts(state.error ?? ''),
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.statusError,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<MyPostsBloc>().add(
                          MyPostsEvent.loadMyPosts(userId: userId),
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
            context.read<MyPostsBloc>().add(
                  MyPostsEvent.loadMyPosts(userId: userId),
                );
            // Wait a bit for the stream to emit
            await Future.delayed(const Duration(milliseconds: 500));
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
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: theme.colors.foregroundSecondary,
                            ),
                            const SizedBox(height: 16),
                            RaqamiText(
                              localizations.noPostsYet,
                              style: RaqamiTextStyles.heading3,
                              textColor: theme.colors.foregroundSecondary,
                            ),
                            const SizedBox(height: 8),
                            RaqamiText(
                              localizations.createYourFirstPostToSeeItHere,
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
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return Column(
                          children: [
                            MyPostCard(
                              post: post,
                              onSoldToggle: (sold) {
                                context.read<MyPostsBloc>().add(
                                      MyPostsEvent.toggleSold(
                                        postId: post.id,
                                        userId: userId,
                                        sold: sold,
                                      ),
                                    );
                              },
                              onPostUpdated: () {
                                // Refresh the list when returning from detail screen
                                context.read<MyPostsBloc>().add(
                                      MyPostsEvent.loadMyPosts(userId: userId),
                                    );
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
