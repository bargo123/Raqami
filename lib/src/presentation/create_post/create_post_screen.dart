import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/core/utils/number_formatter.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/create_post/widgets/plate_input_widget.dart';
import 'package:raqami/src/presentation/create_post/widgets/phone_input_widget.dart';
import 'package:raqami/src/presentation/create_post/widgets/uae_plate_preview.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/components/text_field/raqami_text_field.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _numberController;
  late TextEditingController _plateCodeController;
  late TextEditingController _phoneCodeController;
  late TextEditingController _phonePriceController;
  late TextEditingController _platePriceController;
  PostType? _previousPostType;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _plateCodeController = TextEditingController();
    _phoneCodeController = TextEditingController();
    _phonePriceController = TextEditingController();
    _platePriceController = TextEditingController();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _plateCodeController.dispose();
    _phoneCodeController.dispose();
    _phonePriceController.dispose();
    _platePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

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
            localizations.createPost,
            style: RaqamiTextStyles.bodyLargeSemibold,
            textColor: theme.colors.foregroundPrimary,
          ),
          centerTitle: false,
        ),
        body: BlocConsumer<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.postCreatedSuccessfully),
                  backgroundColor: theme.colors.statusSuccess,
                ),
              );
            }

            if (state.generalError != null) {
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

            // Sync price controllers with state only when post type changes
            // This prevents interference while the user is typing
            final postTypeChanged = _previousPostType != null && 
                                    _previousPostType != state.postType;
            
            if (postTypeChanged) {
              _previousPostType = state.postType;
              
              // Sync the controller for the new post type
              if (state.postType == PostType.phoneNumber) {
                // Format and set phone price
                if (state.phonePrice.isNotEmpty) {
                  final statePrice = state.phonePrice.replaceAll(',', '');
                  final priceNumber = int.tryParse(statePrice);
                  if (priceNumber != null) {
                    final formatter = NumberFormat('#,###');
                    final formatted = formatter.format(priceNumber);
                    _phonePriceController.text = formatted;
                  }
                } else {
                  _phonePriceController.clear();
                }
              } else {
                // Format and set plate price
                if (state.platePrice.isNotEmpty) {
                  final statePrice = state.platePrice.replaceAll(',', '');
                  final priceNumber = int.tryParse(statePrice);
                  if (priceNumber != null) {
                    final formatter = NumberFormat('#,###');
                    final formatted = formatter.format(priceNumber);
                    _platePriceController.text = formatted;
                  }
                } else {
                  _platePriceController.clear();
                }
              }
            } else if (_previousPostType == null) {
              // Initialize on first build
              _previousPostType = state.postType;
              if (state.postType == PostType.phoneNumber && state.phonePrice.isNotEmpty) {
                final statePrice = state.phonePrice.replaceAll(',', '');
                final priceNumber = int.tryParse(statePrice);
                if (priceNumber != null) {
                  final formatter = NumberFormat('#,###');
                  final formatted = formatter.format(priceNumber);
                  _phonePriceController.text = formatted;
                }
              } else if (state.postType == PostType.carPlate && state.platePrice.isNotEmpty) {
                final statePrice = state.platePrice.replaceAll(',', '');
                final priceNumber = int.tryParse(statePrice);
                if (priceNumber != null) {
                  final formatter = NumberFormat('#,###');
                  final formatted = formatter.format(priceNumber);
                  _platePriceController.text = formatted;
                }
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Type Selection
                  _buildPostTypeSelector(context, state, theme, localizations),
                  const SizedBox(height: 32),

                  // Phone Number or Plate Number Field
                  if (state.postType == PostType.phoneNumber)
                    PhoneInputWidget(
                      codeController: _phoneCodeController,
                      numberController: _numberController,
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plate Input Widget (Code | Region | Number)
                        PlateInputWidget(
                          codeController: _plateCodeController,
                          numberController: _numberController,
                        ),
                        const SizedBox(height: 24),
                        // Plate Preview
                        UAEPlatePreview(
                          plateNumber: state.number,
                          plateCode: state.plateCode,
                          emirate: state.emirate,
                          plateType: state.plateType,
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Price Field (different for phone number vs car plate)
                  RaqamiTextField(
                    title: localizations.price,
                    hintText: localizations.enterPrice,
                    controller: state.postType == PostType.phoneNumber 
                        ? _phonePriceController 
                        : _platePriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [NumberFormatter()],
                    prefixIcon: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: RaqamiText(
                          'AED',
                          style: RaqamiTextStyles.bodyBaseMedium,
                          textColor: theme.colors.foregroundSecondary,
                        ),
                      ),
                    ),
                    errorText: ErrorLocalizationHelper.getLocalizedError(
                      state.priceError,
                      localizations,
                    ),
                    onChanged: (value) {
                      // Remove commas before sending to bloc
                      final numericValue = value.replaceAll(',', '');
                      context.read<CreatePostBloc>().add(
                            CreatePostEvent.priceChanged(numericValue),
                          );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Create Button
                  RaqamiButton(
                    text: localizations.createPost,
                    width: double.infinity,
                    isLoading: state.isLoading,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            context.read<CreatePostBloc>().add(
                                  const CreatePostEvent.createPost(),
                                );
                          },
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  Widget _buildPostTypeSelector(
    BuildContext context,
    CreatePostState state,
    dynamic theme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaqamiText(
          localizations.postType,
          style: RaqamiTextStyles.bodySmallSemibold,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeChip(
                context,
                PostType.phoneNumber,
                localizations.phoneNumber,
                state.postType == PostType.phoneNumber,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeChip(
                context,
                PostType.carPlate,
                localizations.carPlate,
                state.postType == PostType.carPlate,
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    PostType type,
    String label,
    bool isSelected,
    dynamic theme,
  ) {
    return InkWell(
      onTap: () {
        context.read<CreatePostBloc>().add(
              CreatePostEvent.postTypeChanged(type),
            );
        _numberController.clear();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colors.tertiary.withOpacity(0.1)
              : theme.colors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colors.tertiary
                : theme.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: RaqamiText(
            label,
            style: RaqamiTextStyles.bodyBaseSemibold,
            textColor: isSelected
                ? theme.colors.tertiary
                : theme.colors.foregroundSecondary,
          ),
        ),
      ),
    );
  }

}

