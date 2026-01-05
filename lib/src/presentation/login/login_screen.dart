import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/presentation/login/bloc/login_bloc.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/navigation/arguments/email_verification_arguments.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/text_field/raqami_text_field.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {

        if (state.isSuccess && state.isEmailVerified) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesConstants.wrapper,
            (route) => false,
          );
        } else if (state.isSuccess && !state.isEmailVerified) {
          Navigator.of(context).pushNamed(
            RoutesConstants.emailVerification,
            arguments: EmailVerificationArguments(
              email: emailController.text,
            ),
          );
        }

        if (state.generalError != null) {
          final localizations = AppLocalizations.of(context)!;
          final localizedError = ErrorLocalizationHelper.getLocalizedError(
            state.generalError!,
            localizations,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizedError ?? state.generalError!),
              backgroundColor: theme.colors.statusError,
            ),
          );
          // Clear the error after showing it
        }
          context.read<LoginBloc>().add(
                const LoginEvent.clearGeneralError(),
              );
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RaqamiText(AppLocalizations.of(context)!.appName, style: RaqamiTextStyles.bodySmallBold),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  RaqamiText(AppLocalizations.of(context)!.welcomeBack, style: RaqamiTextStyles.heading1),
                  RaqamiText(
                    AppLocalizations.of(context)!.logInToContinueShopping,
                    style: RaqamiTextStyles.bodyLargeRegular,
                    textColor: theme.colors.foregroundSecondary,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  RaqamiTextField(
                    title: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.enterYourEmail,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: ErrorLocalizationHelper.getLocalizedError(
                      state.emailError,
                      AppLocalizations.of(context)!,
                    ),
                    onChanged: (value) {
                      context.read<LoginBloc>().add(
                            LoginEvent.emailChanged(value),
                          );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  RaqamiTextField(
                    title: AppLocalizations.of(context)!.password,
                    hintText: AppLocalizations.of(context)!.enterYourPassword,
                    controller: passwordController,
                    obscureText: true,
                    errorText: ErrorLocalizationHelper.getLocalizedError(
                      state.passwordError,
                      AppLocalizations.of(context)!,
                    ),
                    onChanged: (value) {
                      context.read<LoginBloc>().add(
                            LoginEvent.passwordChanged(value),
                          );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  RaqamiButton(
                    width: MediaQuery.of(context).size.width,
                    text: AppLocalizations.of(context)!.logIn,
                    isLoading: state.isLoading,
                    onPressed: () {
                      context.read<LoginBloc>().add(
                            const LoginEvent.login(),
                          );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaqamiText(
                          AppLocalizations.of(context)!.dontHaveAnAccount,
                          style: RaqamiTextStyles.bodyBaseRegular,
                          textColor: theme.colors.foregroundSecondary,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              RoutesConstants.createAccount,
                            );
                          },
                          child: RaqamiText(
                            AppLocalizations.of(context)!.createAccount,
                            style: RaqamiTextStyles.bodyBaseMediumUnderline,
                            textColor: theme.colors.foreground,
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
      },
    );
  }
}