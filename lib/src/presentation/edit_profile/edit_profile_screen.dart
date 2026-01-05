import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/presentation/navigation/arguments/user_arguments.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/ui/components/text_field/raqami_text_field.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';
import 'package:raqami/src/presentation/edit_profile/bloc/edit_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.arguments   });
  final UserArguments arguments;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  late String _initialFullName;
  late String _initialEmail;
  late String _initialPhone;

  @override
  void initState() {
    super.initState();
    _initialFullName = widget.arguments.fullName ?? '';
    _initialEmail = widget.arguments.email ?? '';
    _initialPhone = widget.arguments.phone ?? '';
    
    _fullNameController = TextEditingController(text: _initialFullName);
    _emailController = TextEditingController(text: _initialEmail);
    _phoneController = TextEditingController(text: _initialPhone);

    // Start loading user data
    context.read<EditProfileBloc>().add(EditProfileEvent.started(
      fullName: _initialFullName,
      email: _initialEmail,
      phoneNumber: _initialPhone,
    ));
  }
  
  bool _hasChanges() {
    // Email is not editable, so don't check for email changes
    return _fullNameController.text != _initialFullName ||
        _phoneController.text != _initialPhone;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return Scaffold(
            backgroundColor: theme.colors.backgroundPrimary,
            appBar: AppBar(
              backgroundColor: theme.colors.backgroundPrimary,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colors.foregroundPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: RaqamiText(
                AppLocalizations.of(context)!.editProfile,
                style: RaqamiTextStyles.bodyLargeSemibold,
                textColor: theme.colors.foregroundPrimary,
              ),
              centerTitle: false,
            ),
            body: BlocConsumer<EditProfileBloc, EditProfileState>(
              listener: (context, state) {
                // Update controllers when state changes
                if (_fullNameController.text != state.fullName) {
                  _fullNameController.text = state.fullName;
                }

                if (_emailController.text != state.email) {
                  _emailController.text = state.email;
                }
                if (_phoneController.text != state.phoneNumber) {
                  _phoneController.text = state.phoneNumber;
                }

                // Handle success
                if (state.isSuccess) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
                      backgroundColor: theme.colors.statusSuccess,
                    ),
                  );
                }

                // Handle errors
                if (state.error != null) {
                  final localizations = AppLocalizations.of(context)!;
                  final localizedError = ErrorLocalizationHelper.getLocalizedError(
                    state.error!,
                    localizations,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizedError ?? state.error!),
                      backgroundColor: theme.colors.statusError,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          // Profile Picture Section
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colors.neutral200,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: theme.colors.neutral500,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colors.foregroundPrimary,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: theme.colors.backgroundPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Full Name Field
                          RaqamiTextField(
                            title: AppLocalizations.of(context)!.fullName,
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                            errorText: ErrorLocalizationHelper.getLocalizedError(
                              state.fullNameError,
                              AppLocalizations.of(context)!,
                            ),
                            onChanged: (value) {
                              context.read<EditProfileBloc>().add(
                                EditProfileEvent.fullNameChanged(value),
                              );
                              setState(() {}); // Rebuild to update button state
                            },
                          ),
                          const SizedBox(height: 16),
                          // Email Field (Read-only)
                          RaqamiTextField(
                            title: AppLocalizations.of(context)!.email,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: false,
                            errorText: ErrorLocalizationHelper.getLocalizedError(
                              state.emailError,
                              AppLocalizations.of(context)!,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Phone Number Field
                          RaqamiTextField(
                            title: AppLocalizations.of(context)!.phoneNumber,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            errorText: ErrorLocalizationHelper.getLocalizedError(
                              state.phoneNumberError,
                              AppLocalizations.of(context)!,
                            ),
                            onChanged: (value) {
                              context.read<EditProfileBloc>().add(
                                EditProfileEvent.phoneNumberChanged(value),
                              );
                              setState(() {}); // Rebuild to update button state
                            },
                          ),
                          const SizedBox(height: 80),
                          // Save Button
                          RaqamiButton(
                            text: AppLocalizations.of(context)!.save,
                            width: double.infinity,
                            isLoading: state.isLoading,
                            onPressed: _hasChanges() && !state.isLoading
                                ? () {
                                    context.read<EditProfileBloc>().add(
                                          const EditProfileEvent.updateProfile(),
                                        );
                                  }
                                : null,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// counter = 1 
// counter = 2 