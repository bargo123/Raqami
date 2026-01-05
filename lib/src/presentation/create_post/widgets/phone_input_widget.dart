import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/domain/models/line_type.dart';
import 'package:raqami/src/domain/models/phone_provider.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PhoneInputWidget extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController numberController;

  const PhoneInputWidget({
    super.key,
    required this.codeController,
    required this.numberController,
  });


  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaqamiText(
              localizations.phoneNumber,
              style: RaqamiTextStyles.bodySmallSemibold,
              textColor: theme.colors.foregroundPrimary,
            ),
            const SizedBox(height: 8),
            // Horizontal layout: Provider | Code | Number
            Row(
              children: [
                // Provider Selector
                Flexible(
                  flex: 3,
                  child: _buildProviderSelector(context, state, theme),
                ),
                const SizedBox(width: 8),
                // Code Selector
                Flexible(
                  flex: 3,
                  child: _buildCodeSelector(context, state, theme, localizations),
                ),
                const SizedBox(width: 8),
                // Number Field
                Flexible(
                  flex: 4,
                  child: _buildNumberField(context, state, theme, localizations),
                ),
              ],
            ),
            // Error messages - right after the number field row
            if (state.numberError != null) ...[
              const SizedBox(height: 4),
              RaqamiText(
                ErrorLocalizationHelper.getLocalizedError(
                  state.numberError!,
                  localizations,
                ) ?? state.numberError!,
                style: RaqamiTextStyles.bodySmallRegular,
                textColor: theme.colors.statusError,
              ),
            ],
            const SizedBox(height: 24),
            // Line Type Selector
            Row(
              children: [
                Expanded(
                  child: _buildLineTypeSelector(context, state, theme, localizations),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProviderSelector(
    BuildContext context,
    CreatePostState state,
    dynamic theme,
  ) {
    final selectedProvider = state.phoneProvider;

    return SizedBox(
      height: 56,
      child: DropdownButtonFormField<PhoneProvider>(
        value: selectedProvider,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.colors.backgroundSecondary,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
              color: theme.colors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.foregroundPrimary,
              width: 1.5,
            ),
          ),
        ),
        items: PhoneProvider.values.map((provider) {
          return DropdownMenuItem<PhoneProvider>(
            value: provider,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: switch (provider) {
                    PhoneProvider.du => Assets.images.duIc.image(
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    PhoneProvider.etisalat => Assets.images.etsIc.image(
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    PhoneProvider.virgin => Assets.images.virginIc.image(
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                  },
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null && value != selectedProvider) {
            context.read<CreatePostBloc>().add(
                  CreatePostEvent.phoneProviderChanged(value),
                );
            // Clear code when provider changes
            codeController.clear();
            context.read<CreatePostBloc>().add(
                  CreatePostEvent.phoneCodeChanged(''),
                );
          }
        },
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.colors.foregroundSecondary,
          size: 20,
        ),
        iconSize: 20,
        isExpanded: true,
        dropdownColor: theme.colors.backgroundPrimary,
        selectedItemBuilder: (BuildContext context) {
          return PhoneProvider.values.map<Widget>((PhoneProvider provider) {
            return SizedBox(
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: switch (provider) {
                    PhoneProvider.du => Assets.images.duIc.image(
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    PhoneProvider.etisalat => Assets.images.etsIc.image(
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    PhoneProvider.virgin => Assets.images.virginIc.image(
              
                        fit: BoxFit.cover,
                      ),
                  },
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildCodeSelector(
    BuildContext context,
    CreatePostState state,
    dynamic theme,
    AppLocalizations localizations,
  ) {
    final currentCode = codeController.text.isEmpty ? null : codeController.text;
    final selectedProvider = state.phoneProvider;
    final validCodes = selectedProvider.validCodes;

    return SizedBox(
      height: 56,
      child: DropdownButtonFormField<String>(
        value: currentCode,
        decoration: InputDecoration(
          hintText: localizations.code,
          hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.neutral500,
          ),
          filled: true,
          fillColor: theme.colors.backgroundSecondary,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
              color: theme.colors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colors.foregroundPrimary,
              width: 1.5,
            ),
          ),
          counterText: '',
        ),
        items: validCodes.map((code) {
          return DropdownMenuItem<String>(
            value: code,
            child: Align(
              alignment: Alignment.center,
              child: RaqamiText(
                code,
                style: RaqamiTextStyles.bodyBaseRegular,
                textColor: theme.colors.foregroundPrimary,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            codeController.text = value;
            context.read<CreatePostBloc>().add(
                  CreatePostEvent.phoneCodeChanged(value),
                );
          }
        },
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.colors.foregroundSecondary,
          size: 20,
        ),
        iconSize: 20,
        isExpanded: true,
        dropdownColor: theme.colors.backgroundPrimary,
        style: RaqamiTextStyles.bodyBaseRegular.copyWith(
          color: theme.colors.foregroundPrimary,
        ),
        selectedItemBuilder: (BuildContext context) {
          return validCodes.map<Widget>((String code) {
            return SizedBox(
              width: double.infinity,
              child: Center(
                child: RaqamiText(
                  code,
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.foregroundPrimary,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildNumberField(
    BuildContext context,
    CreatePostState state,
    dynamic theme,
    AppLocalizations localizations,
  ) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: numberController,
        textAlign: TextAlign.center,
        style: RaqamiTextStyles.bodyBaseRegular,
        keyboardType: TextInputType.number,
        maxLength: 7,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(7),
        ],
        decoration: InputDecoration(
          hintText: localizations.number,
          hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
            color: theme.colors.neutral500,
          ),
          filled: true,
          fillColor: theme.colors.backgroundSecondary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: state.numberError != null
                  ? theme.colors.statusError
                  : theme.colors.border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: state.numberError != null
                  ? theme.colors.statusError
                  : theme.colors.border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: state.numberError != null
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
          counterText: '',
        ),
        onChanged: (value) {
          context.read<CreatePostBloc>().add(
                CreatePostEvent.numberChanged(value),
              );
        },
      ),
    );
  }

  Widget _buildLineTypeSelector(
    BuildContext context,
    CreatePostState state,
    dynamic theme,
    AppLocalizations localizations,
  ) {
    final selectedLineType = state.lineType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaqamiText(
          localizations.lineType,
          style: RaqamiTextStyles.bodySmallSemibold,
          textColor: theme.colors.foregroundPrimary,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: DropdownButtonFormField<LineType>(
            value: selectedLineType,
            decoration: InputDecoration(
              hintText: localizations.chooseLineType,
              hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
                color: theme.colors.neutral500,
              ),
              filled: true,
              fillColor: theme.colors.backgroundSecondary,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  color: theme.colors.border,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colors.foregroundPrimary,
                  width: 1.5,
                ),
              ),
            ),
            items: LineType.values.map((lineType) {
              final displayText = switch (lineType) {
                LineType.prepaid => localizations.prepaid,
                LineType.postpaid => localizations.postpaid,
              };
              return DropdownMenuItem<LineType>(
                value: lineType,
                child: RaqamiText(
                  displayText,
                  style: RaqamiTextStyles.bodyBaseRegular,
                  textColor: theme.colors.foregroundPrimary,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<CreatePostBloc>().add(
                      CreatePostEvent.lineTypeChanged(value),
                    );
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: theme.colors.foregroundSecondary,
              size: 20,
            ),
            iconSize: 20,
            isExpanded: true,
            dropdownColor: theme.colors.backgroundPrimary,
            style: RaqamiTextStyles.bodyBaseRegular.copyWith(
              color: theme.colors.foregroundPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

