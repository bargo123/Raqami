import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/presentation/navigation/routes/routes_constants.dart';
import 'package:raqami/src/presentation/email_verification/bloc/email_verification_bloc.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart'
    show RaqamiText;
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    return BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
      listener: (context, state) {
        // Handle success and general errors here
        if (state.isSuccess) {

            Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesConstants.home,
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.accountCreatedSuccessfullyPleaseLogIn),
                backgroundColor: Colors.green,
              ),
            );
        }
        if (state.generalError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.generalError!),
              backgroundColor: theme.colors.statusError,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaqamiText(AppLocalizations.of(context)!.appName, style: RaqamiTextStyles.bodySmallBold),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    RaqamiText(
                      AppLocalizations.of(context)!.verifyYourEmail,
                      style: RaqamiTextStyles.heading1,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    RaqamiText(
                      AppLocalizations.of(context)!.weSentAVerificationEmailTo(state.email ?? AppLocalizations.of(context)!.email),          
                      style: RaqamiTextStyles.bodyLargeRegular,
                      textColor: theme.colors.foregroundSecondary,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    RaqamiButton(
                      width: double.infinity,
                      text: AppLocalizations.of(context)!.verify,
                      isLoading: state.isLoading,
                      onPressed: () {
                        context.read<EmailVerificationBloc>().add(
                              const EmailVerificationEvent.verifyOtp(),
                            );
                      },
                    ),
              
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

