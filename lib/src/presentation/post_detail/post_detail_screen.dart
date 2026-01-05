import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:raqami/gen/assets.gen.dart';
import 'package:raqami/l10n/app_localizations.dart';
import 'package:raqami/src/core/utils/number_formatter.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/domain/models/post_model.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/presentation/post_detail/bloc/post_detail_bloc.dart';
import 'package:raqami/src/presentation/post_detail/widgets/plate_number_input_widget.dart';
import 'package:raqami/src/presentation/post_detail/widgets/plate_code_input_widget.dart';
import 'package:raqami/src/presentation/post_detail/widgets/phone_code_input_widget.dart';
import 'package:raqami/src/presentation/ui/components/button/raqami_button.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/components/text_field/raqami_text_field.dart';
import 'package:raqami/src/presentation/ui/components/neumorphic_toggle.dart';
import 'package:raqami/src/presentation/ui/components/delete_confirmation_dialog.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/src/presentation/widgets/plate_preview.dart';
import 'package:raqami/src/presentation/widgets/phone_preview.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late TextEditingController _numberController;
  late TextEditingController _plateCodeController;
  late TextEditingController _phoneCodeController;
  late TextEditingController _priceController;
  late bool _sold;

  @override
  void initState() {
    super.initState();
    // For phone numbers, extract code and number separately
    if (widget.post.type == PostType.phoneNumber) {
      final numberParts = widget.post.number.split(' ');
      if (numberParts.length >= 2) {
        _phoneCodeController = TextEditingController(text: numberParts[0]);
        _numberController = TextEditingController(text: numberParts[1]);
      } else {
        // Fallback: try to extract first 3 chars as code
        final fullNumber = widget.post.number;
        if (fullNumber.length >= 3) {
          _phoneCodeController = TextEditingController(text: fullNumber.substring(0, 3));
          _numberController = TextEditingController(
            text: fullNumber.length > 3 ? fullNumber.substring(3) : '',
          );
        } else {
          _phoneCodeController = TextEditingController();
          _numberController = TextEditingController(text: widget.post.number);
        }
      }
    } else {
      _phoneCodeController = TextEditingController();
      _numberController = TextEditingController(text: widget.post.number);
    }
    _plateCodeController = TextEditingController(
      text: widget.post.plateCode ?? '',
    );
    _priceController = TextEditingController(
      text: widget.post.price > 0
          ? NumberFormat('#,###').format(widget.post.price)
          : '',
    );
    _sold = widget.post.sold;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _plateCodeController.dispose();
    _phoneCodeController.dispose();
    _priceController.dispose();
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
          title: RaqamiText(
            localizations.editPost,
            style: RaqamiTextStyles.heading3,
            textColor: theme.colors.foregroundPrimary,
          ),
          actions: [
            BlocBuilder<PostDetailBloc, PostDetailState>(
              builder: (context, state) {
                return IconButton(
                  icon: Assets.images.deleteItemIc.svg(),
                  onPressed: state.isDeleting
                      ? null
                      : () => _showDeleteConfirmation(context),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<PostDetailBloc, PostDetailState>(
          listener: (context, state) {
            if (state.isSuccess) {
              // Show success toast
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.postDeletedSuccessfully),
                  backgroundColor: theme.colors.statusSuccess,
                ),
              );
              Navigator.of(
                context,
              ).pop(true); // Return true to indicate success
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: theme.colors.statusError,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plate or Phone Preview
                  if (widget.post.type == PostType.carPlate &&
                      widget.post.emirate != null)
                    Center(
                      child: PlatePreview(
                        emirate: widget.post.emirate,
                        plateNumber: _numberController.text,
                        plateCode: _plateCodeController.text.isEmpty
                            ? null
                            : _plateCodeController.text,
                        plateTypeString: widget.post.plateType,
                        showContainer: true,
                      ),
                    )
                  else if (widget.post.type == PostType.phoneNumber)
                    Center(
                      child: PhonePreview(
                        phoneNumber: _formatPhoneNumberForPreview(
                          _phoneCodeController.text,
                          _numberController.text,
                        ),
                        phoneProvider: widget.post.phoneProvider,
                        showContainer: true,
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colors.neutral100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colors.border),
                      ),
                      child: Center(
                        child: RaqamiText(
                          _numberController.text.isEmpty
                              ? localizations.number
                              : _numberController.text,
                          style: RaqamiTextStyles.heading3,
                          textColor: theme.colors.foregroundPrimary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Plate Number Field (for car plates)
                  if (widget.post.type == PostType.carPlate)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RaqamiText(
                          localizations.plateNumber,
                          style: RaqamiTextStyles.bodySmallSemibold,
                          textColor: theme.colors.foregroundPrimary,
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<PostDetailBloc, PostDetailState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PlateNumberInputWidget(
                                  controller: _numberController,
                                  errorText: state.numberError,
                                  onChanged: (value) {
                                    if (state.numberError != null &&
                                        value.isNotEmpty) {
                                      context.read<PostDetailBloc>().add(
                                        PostDetailEvent.setNumberError(
                                          error: null,
                                        ),
                                      );
                                    }
                                    setState(() {}); // Update preview
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Plate Code Field - only show if plate has a code
                        if (widget.post.plateCode != null &&
                            widget.post.plateCode!.trim().isNotEmpty) ...[
                          RaqamiText(
                            localizations.plateCode,
                            style: RaqamiTextStyles.bodySmallSemibold,
                            textColor: theme.colors.foregroundPrimary,
                          ),
                          const SizedBox(height: 8),
                          BlocBuilder<PostDetailBloc, PostDetailState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PlateCodeInputWidget(
                                    controller: _plateCodeController,
                                    emirate: widget.post.emirate,
                                    plateTypeString: widget.post.plateType,
                                    errorText: state.plateCodeError != null
                                        ? ErrorLocalizationHelper.getLocalizedError(
                                            state.plateCodeError!,
                                            localizations,
                                          ) ?? state.plateCodeError!
                                        : null,
                                    onChanged: (value) {
                                      if (state.plateCodeError != null &&
                                          value.isNotEmpty) {
                                        context.read<PostDetailBloc>().add(
                                          PostDetailEvent.setPlateCodeError(
                                            error: null,
                                          ),
                                        );
                                      }
                                      setState(() {}); // Update preview
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    )
                  else if (widget.post.type == PostType.phoneNumber)
                    // Phone Code and Number Fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Code Field
                        RaqamiText(
                          localizations.code,
                          style: RaqamiTextStyles.bodySmallSemibold,
                          textColor: theme.colors.foregroundPrimary,
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<PostDetailBloc, PostDetailState>(
                          builder: (context, state) {
                            return PhoneCodeInputWidget(
                              controller: _phoneCodeController,
                              phoneProvider: widget.post.phoneProvider,
                              errorText: state.phoneCodeError != null
                                  ? ErrorLocalizationHelper.getLocalizedError(
                                      state.phoneCodeError!,
                                      localizations,
                                    ) ?? state.phoneCodeError!
                                  : null,
                              onChanged: (value) {
                                if (state.phoneCodeError != null && value.isNotEmpty) {
                                  context.read<PostDetailBloc>().add(
                                    PostDetailEvent.setPhoneCodeError(error: null),
                                  );
                                }
                                setState(() {}); // Update preview
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Phone Number Field
                        BlocBuilder<PostDetailBloc, PostDetailState>(
                          builder: (context, state) {
                            return RaqamiTextField(
                              title: localizations.phoneNumber,
                              hintText: localizations.enterPhoneNumber,
                              controller: _numberController,
                              keyboardType: TextInputType.phone,
                              errorText: state.numberError != null
                                  ? ErrorLocalizationHelper.getLocalizedError(
                                      state.numberError!,
                                      localizations,
                                    ) ?? state.numberError!
                                  : null,
                              onChanged: (value) {
                                // Limit to 7 digits
                                if (value.length > 7) {
                                  _numberController.text = value.substring(0, 7);
                                  _numberController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: 7),
                                  );
                                  return;
                                }
                                if (state.numberError != null && value.isNotEmpty) {
                                  context.read<PostDetailBloc>().add(
                                    PostDetailEvent.setNumberError(error: null),
                                  );
                                }
                                setState(() {}); // Update preview
                              },
                            );
                          },
                        ),
                      ],
                    )
                  else
                    // Default number field for other types
                    BlocBuilder<PostDetailBloc, PostDetailState>(
                      builder: (context, state) {
                        return RaqamiTextField(
                          title: localizations.number,
                          hintText: localizations.enterPhoneNumber,
                          controller: _numberController,
                          keyboardType: TextInputType.number,
                          errorText: state.numberError,
                          onChanged: (value) {
                            if (state.numberError != null && value.isNotEmpty) {
                              context.read<PostDetailBloc>().add(
                                PostDetailEvent.setNumberError(error: null),
                              );
                            }
                            setState(() {}); // Update preview
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 5),

                  // Price Field
                  RaqamiTextField(
                    title: localizations.price,
                    hintText: localizations.enterPrice,
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    inputFormatters: [NumberFormatter()],
                    prefixIcon: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: RaqamiText(
                          widget.post.currency,
                          style: RaqamiTextStyles.bodyBaseMedium,
                          textColor: theme.colors.foregroundSecondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),

                  // Sold Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaqamiText(
                        localizations.markAsSold,
                        style: RaqamiTextStyles.bodyBaseSemibold,
                        textColor: theme.colors.foregroundPrimary,
                      ),
                      NeumorphicToggle(
                        value: _sold,
                        onChanged: (value) {
                          setState(() {
                            _sold = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  RaqamiButton(
                    width: double.infinity,
                    text: localizations.saveChanges,
                    onPressed: state.isUpdating || state.isDeleting
                        ? null
                        : () => _saveChanges(context),
                    isLoading: state.isUpdating,
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  String _formatPhoneNumberForPreview(String code, String number) {
    // Combine code and number with space
    if (code.isEmpty && number.isEmpty) {
      return widget.post.number; // Fallback to original
    }
    if (code.isEmpty) {
      return number;
    }
    if (number.isEmpty) {
      return code;
    }
    return '$code $number';
  }

  void _saveChanges(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bloc = context.read<PostDetailBloc>();
    final numericPrice = _priceController.text.replaceAll(',', '');
    final price = numericPrice.isEmpty
        ? 0.0
        : double.tryParse(numericPrice) ?? 0.0;

    // Reset errors
    bloc.add(PostDetailEvent.setNumberError(error: null));
    bloc.add(PostDetailEvent.setPlateCodeError(error: null));
    bloc.add(PostDetailEvent.setPhoneCodeError(error: null));

    bool hasError = false;

    // Validate number field (plate number or phone number)
    if (_numberController.text.trim().isEmpty) {
      bloc.add(
        PostDetailEvent.setNumberError(
          error: widget.post.type == PostType.carPlate
              ? localizations.plateNumberRequired
              : localizations.phoneNumberRequired,
        ),
      );
      hasError = true;
    }

    // Validate plate code if it was originally present
    if (widget.post.type == PostType.carPlate &&
        widget.post.plateCode != null &&
        widget.post.plateCode!.trim().isNotEmpty &&
        _plateCodeController.text.trim().isEmpty) {
      bloc.add(
        PostDetailEvent.setPlateCodeError(
          error: 'plateCodeIsRequired',
        ),
      );
      hasError = true;
    }

    // Validate phone code for phone numbers
    if (widget.post.type == PostType.phoneNumber) {
      if (_phoneCodeController.text.trim().isEmpty) {
        bloc.add(
          PostDetailEvent.setPhoneCodeError(
            error: 'phoneCodeIsRequired',
          ),
        );
        hasError = true;
      }
      // Validate phone number is exactly 7 digits
      final phoneNumber = _numberController.text.trim();
      if (phoneNumber.isEmpty) {
        bloc.add(
          PostDetailEvent.setNumberError(
            error: localizations.phoneNumberRequired,
          ),
        );
        hasError = true;
      } else if (phoneNumber.length != 7) {
        bloc.add(
          PostDetailEvent.setNumberError(
            error: 'phoneNumberMustBe7Digits',
          ),
        );
        hasError = true;
      }
    }

    if (hasError) {
      return;
    }

    // Combine phone code and number for phone number posts
    final fullNumber = widget.post.type == PostType.phoneNumber
        ? '${_phoneCodeController.text.trim()} ${_numberController.text.trim()}'
        : _numberController.text.trim();

    bloc.add(
      PostDetailEvent.updatePost(
        postId: widget.post.id,
        number: fullNumber,
        price: price,
        sold: _sold,
        plateCode: _plateCodeController.text.isEmpty
            ? null
            : _plateCodeController.text,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext stateContext) {
    DeleteConfirmationDialog.showDeletePost(
      context: context,
      onConfirm: () {
        stateContext.read<PostDetailBloc>().add(
          PostDetailEvent.deletePost(postId: widget.post.id),
        );
      },
    );
  }
}
