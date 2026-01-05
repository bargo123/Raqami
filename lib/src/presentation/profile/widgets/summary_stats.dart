import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:raqami/src/presentation/profile/widgets/stat_item.dart';

class SummaryStats extends StatelessWidget {
  const SummaryStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatItem(
              value: state.wishlistCount.toString(),
              label: AppLocalizations.of(context)!.wishlist,
            ),
            StatItem(
              value: state.myPostsCount.toString(),
              label: AppLocalizations.of(context)!.myPosts,
            ),
          ],
        );
      },
    );
  }
}

