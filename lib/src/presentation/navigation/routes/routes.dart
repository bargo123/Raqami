import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/di/di_container.dart';
import 'package:raqami/src/presentation/create_account/bloc/create_account_bloc.dart';
import 'package:raqami/src/presentation/create_account/create_account_screen.dart';
import 'package:raqami/src/presentation/login/bloc/login_bloc.dart';
import 'package:raqami/src/presentation/login/login_screen.dart';
import 'package:raqami/src/presentation/navigation/arguments/user_arguments.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/email_verification/bloc/email_verification_bloc.dart';
import 'package:raqami/src/presentation/email_verification/email_verification_screen.dart';
import 'package:raqami/src/presentation/home/home_screen.dart';
import 'package:raqami/src/presentation/wrapper/wrapper_screen.dart';
import 'package:raqami/src/presentation/wrapper/bloc/wrapper_bloc.dart';
import 'package:raqami/src/presentation/navigation/arguments/email_verification_arguments.dart';
import 'package:raqami/src/presentation/edit_profile/edit_profile_screen.dart';
import 'package:raqami/src/presentation/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:raqami/src/presentation/create_post/create_post_screen.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/domain/use_case/create_post_use_case.dart';
import 'package:raqami/src/presentation/post_detail/post_detail_screen.dart';
import 'package:raqami/src/presentation/post_detail/bloc/post_detail_bloc.dart';
import 'package:raqami/src/presentation/post_info/post_info_screen.dart';
import 'package:raqami/src/presentation/post_info/bloc/post_info_bloc.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/presentation/about_us/about_us_screen.dart';
import 'package:raqami/src/presentation/contact_us/contact_us_screen.dart';
import 'package:raqami/src/presentation/privacy_policy/privacy_policy_screen.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.get<LoginBloc>(),
            child: const LoginScreen(),
          ),
        );

      case RoutesConstants.createAccount:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.get<CreateAccountBloc>(),
            child: const CreateAccountScreen(),
          ),
        );

      case RoutesConstants.emailVerification:
        final args = settings.arguments is Map<String, dynamic>
            ? EmailVerificationArguments.fromMap(settings.arguments as Map<String, dynamic>)
            : settings.arguments as EmailVerificationArguments?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final bloc = di.get<EmailVerificationBloc>();
              if (args != null) {
                bloc.add(EmailVerificationEvent.started(
                  email: args.email,
                ));
              }
              return bloc;
            },
            child: const EmailVerificationScreen(),
          ),
        );

      case RoutesConstants.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case RoutesConstants.wrapper:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.get<WrapperBloc>(),
            child: const WrapperScreen(),
          ),
        );

      case RoutesConstants.editProfile:
        final args = settings.arguments is Map<String, dynamic>
            ? UserArguments.fromMap(settings.arguments as Map<String, dynamic>)
            : settings.arguments as UserArguments?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.get<EditProfileBloc>(),
            child: EditProfileScreen(arguments: args ?? UserArguments()),
          ),
        );

      case RoutesConstants.createPost:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CreatePostBloc(
              createPostUseCase: di.get<CreatePostUseCase>(),
            )..add(const CreatePostEvent.started()),
            child: const CreatePostScreen(),
          ),
        );

      case RoutesConstants.postDetail:
        final post = settings.arguments as PostModel?;
        if (post == null) {
          return MaterialPageRoute(
            builder: (context) {
              final localizations = AppLocalizations.of(context)!;
              return Scaffold(
                body: Center(
                  child: Text(localizations.postNotFound),
                ),
              );
            },
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.get<PostDetailBloc>(),
            child: PostDetailScreen(post: post),
          ),
        );

      case RoutesConstants.postInfo:
        final args = settings.arguments;
        PostModel? post;
        String userId = '';
        
        if (args is Map<String, dynamic>) {
          post = args['post'] as PostModel?;
          userId = args['userId'] as String? ?? '';
        } else if (args is PostModel) {
          // Backward compatibility: if only post is passed
          post = args;
        }
        
        if (post == null) {
          return MaterialPageRoute(
            builder: (context) {
              final localizations = AppLocalizations.of(context)!;
              return Scaffold(
                body: Center(
                  child: Text(localizations.postNotFound),
                ),
              );
            },
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.get<PostInfoBloc>(param1: post!),
            child: PostInfoScreen(userId: userId),
          ),
        );

      case RoutesConstants.aboutUs:
        return MaterialPageRoute(
          builder: (_) => const AboutUsScreen(),
        );

      case RoutesConstants.contactUs:
        return MaterialPageRoute(
          builder: (_) => const ContactUsScreen(),
        );

      case RoutesConstants.privacyPolicy:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            final localizations = AppLocalizations.of(context)!;
            return Scaffold(
              body: Center(
                child: Text(localizations.noRouteDefinedFor(settings.name ?? '')),
              ),
            );
          },
        );
    }
  }
}

