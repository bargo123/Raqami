import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/domain/constants/firestore_constants.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/presentation/home/bloc/home_bloc.dart';
import 'package:raqami/src/presentation/home/widgets/posts_list.dart';
import 'package:raqami/src/presentation/home/widgets/plate_filter_widget.dart';
import 'package:raqami/src/presentation/home/widgets/phone_filter_widget.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
    // Get HomeBloc from context to ensure it's available
    final homeBloc = context.read<HomeBloc>();

    return Scaffold(
        backgroundColor: theme.colors.backgroundPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.colors.backgroundPrimary,
          elevation: 0,
          title: RaqamiText(
            localizations.home,
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
        body: Column(
          children: [
            // Show filter for Phone Number tab
            if (_tabController.index == 0)
              Builder(
                builder: (context) => PhoneFilterWidget(
                  onSearch: ({
                    PhoneProvider? provider,
                    String? code,
                  }) {
                    context.read<HomeBloc>().add(
                      HomeEvent.filterPhoneNumbers(
                        provider: provider,
                        code: code,
                      ),
                    );
                  },
                ),
              ),
            // Show filter for Car Plate tab
            if (_tabController.index == 1)
              Builder(
                builder: (context) => PlateFilterWidget(
                  onSearch: ({
                    UAEEmirate? emirate,
                    String? code,
                    int? digitCount,
                  }) {
                    context.read<HomeBloc>().add(
                      HomeEvent.filterCarPlates(
                        emirate: emirate,
                        code: code,
                        digitCount: digitCount,
                      ),
                    );
                  },
                ),
              ),
            Expanded(
              child: BlocProvider.value(
                value: homeBloc,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PostsList(
                      postType: PostType.phoneNumber,
                      countryCode: FirestoreConstants.countryCodeUAE,
                    ),
                    PostsList(
                      postType: PostType.carPlate,
                      countryCode: FirestoreConstants.countryCodeUAE,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
