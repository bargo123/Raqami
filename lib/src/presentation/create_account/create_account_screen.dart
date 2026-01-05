import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/presentation/create_account/bloc/create_account_bloc.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/navigation/arguments/email_verification_arguments.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/text_field/raqami_text_field.dart';
import 'package:raqami/src/presentation/ui/components/text_field/raqami_phone_field.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CreateAccountBloc, CreateAccountState>(
            listener: (context, state) {
              if (state.isSuccess) {
                // Navigate to email verification screen
                Navigator.of(context).pushNamed(
                  RoutesConstants.emailVerification,
                  arguments: EmailVerificationArguments(
                    email: state.email,
                  ),
                );
              }
              // Only show snackbar for general errors (network, server, etc.)
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
              }
                context.read<CreateAccountBloc>().add(
                      const CreateAccountEvent.emptyErrors(),
                    );
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    RaqamiText(AppLocalizations.of(context)!.appName, style: RaqamiTextStyles.bodySmallBold),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    RaqamiText(
                      AppLocalizations.of(context)!.createYourRaqamiAccount,
                      style: RaqamiTextStyles.heading1,
                    ),
                    RaqamiText(
                      AppLocalizations.of(context)!.joinRaqamiAndFindYourNumber,
                      style: RaqamiTextStyles.bodyLargeRegular,
                      textColor: theme.colors.foregroundSecondary,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    RaqamiTextField(
                      title: AppLocalizations.of(context)!.fullName,
                      hintText: AppLocalizations.of(context)!.johnDoe,
                      controller: nameController,
                      errorText: ErrorLocalizationHelper.getLocalizedError(
                        state.nameError,
                        AppLocalizations.of(context)!,
                      ),
                      onChanged: (value) {
                        context.read<CreateAccountBloc>().add(
                              CreateAccountEvent.nameChanged(value),
                            );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                        context.read<CreateAccountBloc>().add(
                              CreateAccountEvent.emailChanged(value),
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
                        context.read<CreateAccountBloc>().add(
                              CreateAccountEvent.passwordChanged(value),
                            );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    RaqamiPhoneField(
                      title: AppLocalizations.of(context)!.phoneNumber,
                      hintText: AppLocalizations.of(context)!.enterPhoneNumber,
                      controller: phoneController,
                      errorText: ErrorLocalizationHelper.getLocalizedError(
                        state.phoneNumberError,
                        AppLocalizations.of(context)!,
                      ),
                      onInputChanged: (PhoneNumber number) {
                        if (number.phoneNumber != null) {
                          context.read<CreateAccountBloc>().add(
                                CreateAccountEvent.phoneNumberChanged(number.phoneNumber!),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: state.termsAccepted,
                              onChanged: (value) {
                                context.read<CreateAccountBloc>().add(
                                      CreateAccountEvent.termsAcceptedChanged(value ?? false),
                                    );
                              },
                              activeColor: theme.colors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    RaqamiText(
                                      AppLocalizations.of(context)!.iAgreeToThe,
                                      style: RaqamiTextStyles.bodyBaseRegular,
                                      textColor: theme.colors.foregroundSecondary,
                                    ),
                                    RaqamiText(
                                      AppLocalizations.of(context)!.termsAndPrivacyPolicy,
                                      style: RaqamiTextStyles.bodyBaseRegular,
                                      textColor: theme.colors.foregroundPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.termsError != null) ...[
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: Text(
                              ErrorLocalizationHelper.getLocalizedError(
                                state.termsError!,
                                AppLocalizations.of(context)!,
                              ) ?? state.termsError!,
                              style: RaqamiTextStyles.bodySmallRegular.copyWith(
                                color: theme.colors.statusError,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    RaqamiButton(
                      width: double.infinity,
                      text: AppLocalizations.of(context)!.createAccount,
                      isLoading: state.isLoading,
                      onPressed: () {
                        context.read<CreateAccountBloc>().add(
                              const CreateAccountEvent.createAccount(),
                            );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03 ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaqamiText(
                            AppLocalizations.of(context)!.alreadyHaveAnAccount,
                            style: RaqamiTextStyles.bodyBaseRegular,
                            textColor: theme.colors.foregroundSecondary,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: RaqamiText(
                              AppLocalizations.of(context)!.logIn,
                              style: RaqamiTextStyles.bodyBaseMediumUnderline,
                              textColor: theme.colors.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
            },
          ),
        ),
      );
  }
}

