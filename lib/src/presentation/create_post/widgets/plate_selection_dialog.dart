import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/domain/models/plate_type.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PlateSelectionDialog extends StatefulWidget {
  final PlateSelection? selectedPlate;
  final TextEditingController codeController;
  final List<PlateSelection> allPlateSelections;

  const PlateSelectionDialog({
    super.key,
    required this.selectedPlate,
    required this.codeController,
    required this.allPlateSelections,
  });

  @override
  State<PlateSelectionDialog> createState() => _PlateSelectionDialogState();
}

class _PlateSelectionDialogState extends State<PlateSelectionDialog> {
  late PlateSelection? _selectedPlate;

  @override
  void initState() {
    super.initState();
    _selectedPlate = widget.selectedPlate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return Dialog(
      backgroundColor: theme.colors.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaqamiText(
              'Select Plate Region',
              style: RaqamiTextStyles.bodyLargeSemibold,
              textColor: theme.colors.foregroundPrimary,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.allPlateSelections.length,
                itemBuilder: (context, index) {
                  final selection = widget.allPlateSelections[index];
                  final isSelected = _selectedPlate?.emirate == selection.emirate &&
                      _selectedPlate?.plateType == selection.plateType;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPlate = selection;
                      });
                      context.read<CreatePostBloc>().add(
                            CreatePostEvent.emirateChanged(selection.emirate),
                          );
                      context.read<CreatePostBloc>().add(
                            CreatePostEvent.plateTypeChanged(
                              selection.plateType == PlateType.classic
                                  ? 'Classic'
                                  : 'Standard',
                            ),
                          );
                      if (!selection.requiresCode) {
                        widget.codeController.clear();
                        context.read<CreatePostBloc>().add(
                              const CreatePostEvent.plateCodeChanged(''),
                            );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: RaqamiText(
                              selection.displayName,
                              style: RaqamiTextStyles.bodyBaseSemibold,
                              textColor: theme.colors.foregroundPrimary,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: theme.colors.tertiary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

