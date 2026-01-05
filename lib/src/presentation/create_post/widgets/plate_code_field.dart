import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/src/domain/models/plate_selection.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PlateCodeField extends StatelessWidget {
  final PlateSelection? selectedPlate;

  const PlateCodeField({
    super.key,
    required this.selectedPlate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        final validCodes = selectedPlate?.validCodes ?? [];
        final currentCode = state.plateCode.isEmpty ? null : state.plateCode;

        return SizedBox(
          height: 56,
          child: DropdownButtonFormField<String>(
            
            value: currentCode,
            decoration: InputDecoration(
              hintText: 'Code',
              hintStyle: RaqamiTextStyles.bodyBaseRegular.copyWith(
                color: theme.colors.neutral500,
              ),
              filled: true,
              fillColor: theme.colors.backgroundSecondary,
              // contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              isDense: true,
              border: OutlineInputBorder(
              
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: state.plateCodeError != null
                      ? theme.colors.statusError
                      : theme.colors.border,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: state.plateCodeError != null
                      ? theme.colors.statusError
                      : theme.colors.border,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: state.plateCodeError != null
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
                context.read<CreatePostBloc>().add(
                      CreatePostEvent.plateCodeChanged(value),
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
      },
    );
  }
}

