import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/src/core/localization/error_localization_helper.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/domain/models/post_type.dart';
import 'package:raqami/src/domain/models/uae_emirate.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/create_post/widgets/plate_code_field.dart';
import 'package:raqami/src/presentation/create_post/widgets/plate_number_field.dart';
import 'package:raqami/src/presentation/create_post/widgets/plate_region_selector.dart';
import 'package:raqami/src/presentation/create_post/widgets/plate_selection_dialog.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';
import 'package:raqami/l10n/app_localizations.dart';

class PlateInputWidget extends StatefulWidget {
  final TextEditingController codeController;
  final TextEditingController numberController;

  const PlateInputWidget({
    super.key,
    required this.codeController,
    required this.numberController,
  });

  @override
  State<PlateInputWidget> createState() => _PlateInputWidgetState();
}

class _PlateInputWidgetState extends State<PlateInputWidget> {
  PlateSelection? _selectedPlate;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with Dubai standard as default
    _selectedPlate = PlateSelection(
      emirate: UAEEmirate.dubai,
      plateType: PlateType.standard,
    );
  }

  List<PlateSelection> get _allPlateSelections {
    final List<PlateSelection> selections = [];
    for (var emirate in UAEEmirate.values) {
      selections.addAll(emirate.plateSelections);
    }
    return selections;
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        // Initialize bloc state with Dubai if not already set and post type is carPlate
        if (!_hasInitialized && 
            state.postType == PostType.carPlate && 
            state.emirate == null) {
          _hasInitialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CreatePostBloc>().add(
                  CreatePostEvent.emirateChanged(UAEEmirate.dubai),
                );
            context.read<CreatePostBloc>().add(
                  const CreatePostEvent.plateTypeChanged('Standard'),
                );
          });
          return;
        }
        
        // Sync number controller with state only when post type is carPlate
        if (state.postType == PostType.carPlate && 
            widget.numberController.text != state.number) {
          widget.numberController.text = state.number;
        }
        
        // Update selected plate based on state
        if (state.emirate != null) {
          final plateType = state.plateType == 'Classic' 
              ? PlateType.classic 
              : PlateType.standard;
          final currentSelection = PlateSelection(
            emirate: state.emirate!,
            plateType: plateType,
          );
          if (_selectedPlate?.emirate != state.emirate || 
              _selectedPlate?.plateType != plateType) {
            setState(() {
              _selectedPlate = currentSelection;
              if (!currentSelection.requiresCode) {
                // Clear code when switching to a plate that doesn't require code
                context.read<CreatePostBloc>().add(
                      const CreatePostEvent.plateCodeChanged(''),
                    );
              }
            });
          }
        }
      },
      builder: (context, state) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaqamiText(
              localizations.plateNumber,
              style: RaqamiTextStyles.bodySmallSemibold,
              textColor: theme.colors.foregroundPrimary,
            ),
            const SizedBox(height: 8),
            // Horizontal layout: Code | Region | Number
            Row(
              children: [
                // Code Field (only if required)
                if (_selectedPlate?.requiresCode ?? true) ...[
                  Flexible(
                    flex: 3,
                    child: PlateCodeField(selectedPlate: _selectedPlate),
                  ),
                  const SizedBox(width: 8),
                ],
                // Region Selector
                Flexible(
                  flex: 4,
                  child: PlateRegionSelector(
                    selectedPlate: _selectedPlate,
                    onTap: () => _showPlateSelectionDialog(context),
                  ),
                ),
                const SizedBox(width: 8),
                // Number Field
                Flexible(
                  flex: 3,
                  child: PlateNumberField(controller: widget.numberController),
                ),
              ],
            ),
            // Error messages
            if (state.plateCodeError != null) ...[
              const SizedBox(height: 4),
              RaqamiText(
                ErrorLocalizationHelper.getLocalizedError(
                  state.plateCodeError,
                  localizations,
                ) ?? state.plateCodeError!,
                style: RaqamiTextStyles.bodySmallRegular,
                textColor: theme.colors.statusError,
              ),
            ],
            if (state.numberError != null) ...[
              const SizedBox(height: 4),
              RaqamiText(
                ErrorLocalizationHelper.getLocalizedError(
                  state.numberError,
                  localizations,
                ) ?? state.numberError!,
                style: RaqamiTextStyles.bodySmallRegular,
                textColor: theme.colors.statusError,
              ),
            ],
          ],
        );
      },
    );
  }

  void _showPlateSelectionDialog(BuildContext context) {
    final bloc = context.read<CreatePostBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: PlateSelectionDialog(
          selectedPlate: _selectedPlate,
          codeController: widget.codeController,
          allPlateSelections: _allPlateSelections,
        ),
      ),
    );
  }
}

