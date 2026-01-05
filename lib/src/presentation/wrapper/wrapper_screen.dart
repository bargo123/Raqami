import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/home/home_screen.dart';
import 'package:raqami/src/presentation/home/bloc/home_bloc.dart';
import 'package:raqami/src/presentation/my_posts/my_posts_screen.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/wishlist/wishlist_screen.dart';
import 'package:raqami/src/presentation/profile/profile_screen.dart';
import 'package:raqami/src/presentation/ui/components/raqami_bottom_nav_bar/raqami_bottom_navbar.dart';
import 'package:raqami/src/presentation/ui/components/raqami_bottom_nav_bar/raqami_bottom_navbar_items.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';
import 'package:raqami/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:raqami/src/presentation/wishlist/bloc/wishlist_bloc.dart';
import 'package:raqami/src/presentation/my_posts/bloc/my_posts_bloc.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/di/di_container.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<WrapperBloc>().add(const WrapperEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<WrapperBloc, WrapperState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(child: _TabContentWidget(tabIndex: _currentIndex)),
             
            ],
          ),
          extendBody: true,
          bottomSheet: RaqamiBottomNavbar(
            selectedIndex: _currentIndex,
            navItems: [
              RaqamiBottomNavBarItems(
                selectedIcon: Assets.images.selectedHome.svg(),
                unselectedIcon: Assets.images.unselectedHome.svg(),
                title: localizations.home,
              ),
              RaqamiBottomNavBarItems(
                selectedIcon: Assets.images.selectedCategory.svg(),
                unselectedIcon: Assets.images.unselectedCategory.svg(),
                title: localizations.myPosts,
              ),
              RaqamiBottomNavBarItems(
                selectedIcon: Assets.images.selectedHeart.svg(),
                unselectedIcon: Assets.images.unselectedHeart.svg(),
                title: localizations.wishlist,
              ),
              RaqamiBottomNavBarItems(
                selectedIcon: Assets.images.selectedProfile.svg(),
                unselectedIcon: Assets.images.unselectedProfile.svg(),
                title: localizations.profile,
              ),
            ],
            onNavBarCallBack: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
              
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(RoutesConstants.createPost);
              },
              backgroundColor: theme.colors.tertiary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: RaqamiText(
                localizations.createPost,
                style: RaqamiTextStyles.bodySmallSemibold,
                textColor: theme.colors.secondary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabContentWidget extends StatelessWidget {
  const _TabContentWidget({required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WrapperBloc, WrapperState>(
      builder: (context, wrapperState) {
        final userId = wrapperState.userData?.uid ?? '';

        return LazyLoadIndexedStack(
          index: tabIndex,
          children: [
            BlocProvider(
              create: (context) => di.get<HomeBloc>()..add(const HomeEvent.started()),
              child: const HomeScreen(),
            ),
            if (userId.isNotEmpty)
              BlocProvider(
                create: (context) {
                  final bloc = di.get<MyPostsBloc>();
                  bloc.add(MyPostsEvent.loadMyPosts(userId: userId));
                  return bloc;
                },
                child: const MyPostsScreen(),
              )
            else
              const MyPostsScreen(),
            if (userId.isNotEmpty)
              BlocProvider(
                create: (context) {
                  final bloc = di.get<WishlistBloc>();
                  bloc.add(WishlistEvent.loadLikedPosts(userId: userId));
                  return bloc;
                },
                child: const WhislistScreen(),
              )
            else
              const WhislistScreen(),
            BlocProvider(
              create: (context) {
                final bloc = di.get<ProfileBloc>();
                bloc.add(ProfileEvent.loadMyPostsCount(userId: userId));
                bloc.add(ProfileEvent.loadWishlistCount(userId: userId));
                return bloc;
              },
              child: const ProfileScreen(),
            ),
          ],
        );
      },
    );
  }
}
