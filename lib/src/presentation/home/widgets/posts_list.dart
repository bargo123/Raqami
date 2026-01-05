import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/home/bloc/home_bloc.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/widgets/post_card.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';

class PostsList extends StatefulWidget {
  final PostType postType;
  final String countryCode;

  const PostsList({
    super.key,
    required this.postType,
    required this.countryCode,
  });

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Get the appropriate posts and loading state based on post type
        final isLoading = widget.postType == PostType.phoneNumber
            ? state.isLoadingPhoneNumbers
            : state.isLoadingCarPlates;
        final isLoadingMore = widget.postType == PostType.phoneNumber
            ? state.isLoadingMorePhoneNumbers
            : state.isLoadingMoreCarPlates;
        final error = widget.postType == PostType.phoneNumber
            ? state.phoneNumberError
            : state.carPlateError;
        final posts = widget.postType == PostType.phoneNumber
            ? state.phoneNumberPosts
            : state.carPlatePosts;
        final hasMore = widget.postType == PostType.phoneNumber
            ? state.hasMorePhoneNumbers
            : state.hasMoreCarPlates;

        if (isLoading && posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaqamiText(
                  'Error loading posts: $error',
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.statusError,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (widget.postType == PostType.phoneNumber) {
                      context.read<HomeBloc>().add(
                        HomeEvent.loadPhoneNumbers(
                          countryCode: widget.countryCode,
                        ),
                      );
                    } else {
                      context.read<HomeBloc>().add(
                        HomeEvent.loadCarPlates(
                          countryCode: widget.countryCode,
                        ),
                      );
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (widget.postType == PostType.carPlate) {
              context.read<HomeBloc>().add(
                HomeEvent.loadCarPlates(
                  countryCode: widget.countryCode,
                ),
              );
              // Wait for loading to complete
              await context.read<HomeBloc>().stream.firstWhere(
                (state) => !state.isLoadingCarPlates,
              );
            } else {
              context.read<HomeBloc>().add(
                HomeEvent.loadPhoneNumbers(
                  countryCode: widget.countryCode,
                ),
              );
              // Wait for loading to complete
              await context.read<HomeBloc>().stream.firstWhere(
                (state) => !state.isLoadingPhoneNumbers,
              );
            }
          },
          child: posts.isEmpty && !isLoading
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
                              Icons.description_outlined,
                              size: 64,
                              color: theme.colors.foregroundSecondary,
                            ),
                            const SizedBox(height: 16),
                            RaqamiText(
                              localizations.noPostsAvailable,
                              style: RaqamiTextStyles.bodyBaseRegular,
                              textColor: theme.colors.foregroundSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    // Load more when user scrolls near the bottom
                    if (hasMore &&
                        !isLoadingMore &&
                        scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                      if (widget.postType == PostType.phoneNumber) {
                        context.read<HomeBloc>().add(
                          HomeEvent.loadPhoneNumbers(
                            countryCode: widget.countryCode,
                            loadMore: true,
                          ),
                        );
                      } else {
                        context.read<HomeBloc>().add(
                          HomeEvent.loadCarPlates(
                            countryCode: widget.countryCode,
                            loadMore: true,
                          ),
                        );
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == posts.length) {
                        // Show loading indicator at the bottom
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final post = posts[index];
                      return BlocBuilder<WrapperBloc, WrapperState>(
                        builder: (context, wrapperState) {
                          final userId = wrapperState.userData?.uid ?? '';
                          return Column(
                            children: [
                              PostCard(
                                post: post,
                                userId: userId,
                                onLikeTap: (val) {
                                  context.read<HomeBloc>().add(
                                    HomeEvent.likePost(
                                      postId: post.id,
                                      userId: userId,
                                    ),
                                  );
                                  return Future.value(val);
                                },
                              ),
                              if (index == posts.length - 1)
                              const SizedBox(height: 170),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

