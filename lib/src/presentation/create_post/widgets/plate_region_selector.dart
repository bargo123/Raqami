import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PlateRegionSelector extends StatelessWidget {
  final PlateSelection? selectedPlate;
  final VoidCallback onTap;

  const PlateRegionSelector({
    super.key,
    required this.selectedPlate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state.emirateError != null
                    ? theme.colors.statusError
                    : theme.colors.border,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colors.foregroundSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: selectedPlate != null
                      ? Text(
                          selectedPlate!.displayName,
                          style: RaqamiTextStyles.bodyBaseRegular.copyWith(
                            color: theme.colors.foregroundPrimary,
                          ),
                          textAlign: TextAlign.left,
                        )
                      : Text(
                          'Select Region',
                          style: RaqamiTextStyles.bodyBaseRegular.copyWith(
                            color: theme.colors.foregroundSecondary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

