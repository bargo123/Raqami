import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:raqami/firebase_options.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/utils/language_preference_manager.dart';
import 'package:raqami/src/di/di_container.dart';
import 'package:raqami/src/domain/repositories/auth_repository.dart';
import 'package:raqami/src/presentation/navigation/routes/routes.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme_data.dart';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = di.get<AuthRepository>().currentUser;
    final languageManager = di.get<LanguagePreferenceManager>();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguagePreferenceManager>.value(
          value: languageManager,
        ),
      ],
      child: Consumer<LanguagePreferenceManager>(
        builder: (context, languageManager, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.of(context).copyWith(surface: appTheme.colors.baseWhite),
              useMaterial3: true,
            ),
            locale: Locale(languageManager.currentLanguage),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            initialRoute: currentUser?.uid != null ? RoutesConstants.wrapper : RoutesConstants.login,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: (context, child) => RaqamiTheme(data: appTheme, child: child!),
          );
        },
      ),
    );
  }
}

