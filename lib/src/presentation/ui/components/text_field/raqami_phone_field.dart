import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class RaqamiPhoneField extends StatefulWidget {
  final String title;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(PhoneNumber)? onInputChanged;
  final bool enabled;
  final String? errorText;
  final String? initialValue;
  final String? initialCountry;

  const RaqamiPhoneField({
    super.key,
    required this.title,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onInputChanged,
    this.enabled = true,
    this.errorText,
    this.initialValue,
    this.initialCountry,
  });

  @override
  State<RaqamiPhoneField> createState() => _RaqamiPhoneFieldState();
}

class _RaqamiPhoneFieldState extends State<RaqamiPhoneField> {
  PhoneNumber? _initialPhoneNumber;
  String? _validationError;
  String? _currentPhoneNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeCountry();
  }
  
  Future<void> _validatePhoneNumber(PhoneNumber number) async {
    if (number.phoneNumber == null || number.phoneNumber!.isEmpty) {
      setState(() {
        _validationError = null;
      });
      return;
    }
    
    try {
      // Use the package's validation utility
      bool? isValid = await PhoneNumberUtil.isValidNumber(
        phoneNumber: number.phoneNumber!,
        isoCode: number.isoCode ?? 'US',
      );
      
      setState(() {
        _validationError = (isValid == true)
            ? null 
            : 'Please enter a valid phone number for ${number.isoCode ?? 'selected country'}';
      });
    } catch (e) {
      setState(() {
        _validationError = 'Invalid phone number format';
      });
    }
  }

  void _initializeCountry() {
    String countryCode;
    
    // Use provided initial country if available
    if (widget.initialCountry != null && widget.initialCountry!.length == 2) {
      countryCode = widget.initialCountry!.toUpperCase();
    } else {
      // Try to get country from device locale
      try {
        final locale = Localizations.localeOf(context);
        countryCode = locale.countryCode ?? 'US';
      } catch (e) {
        // Fallback: try Platform locale
        try {
          final locale = Platform.localeName;
          if (locale.contains('_')) {
            countryCode = locale.split('_').last.toUpperCase();
          } else if (locale.length == 2) {
            countryCode = locale.toUpperCase();
          } else {
            countryCode = 'US'; // Default fallback
          }
        } catch (e2) {
          countryCode = 'US'; // Default fallback
        }
      }
    }

    // Validate country code is 2 characters
    if (countryCode.length != 2) {
      countryCode = 'US';
    }

    setState(() {
      _initialPhoneNumber = widget.initialValue != null
          ? PhoneNumber(
              isoCode: countryCode,
              phoneNumber: widget.initialValue,
            )
          : PhoneNumber(isoCode: countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    // Show loading or default while country is being detected
    if (_initialPhoneNumber == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: RaqamiTextStyles.bodySmallSemibold,
          ),
          const SizedBox(height: 8),
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: theme.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colors.border),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
    dialogTheme: DialogThemeData(backgroundColor: theme.colors.baseWhite),
        scaffoldBackgroundColor: theme.colors.baseWhite,
        cardColor: theme.colors.baseWhite,
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.foregroundPrimary,
            fontSize: 10
            
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          filled: false,
          fillColor: theme.colors.backgroundSecondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.foregroundPrimary,
              width: 1,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.foregroundPrimary,
              width: 1,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.foregroundPrimary,
              width: 1.5,
            ),
          ),
          hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.neutral500,
          ),
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyLarge: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.foregroundPrimary,
          ),
          bodyMedium: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.foregroundPrimary,
          ),
          titleMedium: RaqamiTextStyles.bodyBaseSemibold.copyWith(
            color: theme.colors.foregroundPrimary,
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: theme.colors.foregroundPrimary,
          iconColor: theme.colors.foregroundPrimary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: RaqamiTextStyles.bodySmallSemibold,
          ),
          const SizedBox(height: 8),
          Form(
            key: _formKey,
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                // Track current phone number
                setState(() {
                  _currentPhoneNumber = number.phoneNumber;
                });
                
                // Clear validation error immediately if field is empty
                if (number.phoneNumber == null || number.phoneNumber!.isEmpty) {
                  setState(() {
                    _validationError = null;
                  });
                } else {
                  // Validate phone number only if not empty
                  _validatePhoneNumber(number);
                }
                
                if (widget.onInputChanged != null) {
                  widget.onInputChanged!(number);
                }
                if (widget.onChanged != null && number.phoneNumber != null) {
                  widget.onChanged!(number.phoneNumber!);
                }
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
                useEmoji: true,
                leadingPadding: 12,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                // Clear error if field is empty
                if (value == null || value.isEmpty) {
                  return null;
                }
                // Use custom error if available, otherwise use validation error
                if (widget.errorText != null) {
                  return widget.errorText;
                }
                return _validationError;
              },
          selectorTextStyle: RaqamiTextStyles.bodyBaseRegular,
          initialValue: _initialPhoneNumber,
          textFieldController: widget.controller,
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputDecoration: InputDecoration(
            hintText: widget.hintText ?? 'Enter phone number',
            hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
              color: theme.colors.neutral500,
            ),
            filled: true,
            fillColor: theme.colors.backgroundSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colors.border,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? theme.colors.statusError
                    : theme.colors.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? theme.colors.statusError
                    : theme.colors.foregroundPrimary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colors.statusError,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colors.statusError,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colors.border,
                width: 1,
              ),
            ),
            errorText: (_currentPhoneNumber == null || _currentPhoneNumber!.isEmpty)
                ? null 
                : (widget.errorText ?? _validationError),
            errorStyle: RaqamiTextStyles.bodySmallRegular.copyWith(
              color: theme.colors.statusError,
            ),
            errorMaxLines: 3,
          ),
          textStyle: RaqamiTextStyles.bodyBaseRegular,
            ),
          ),
        ],
      ),
    );
  }
}

