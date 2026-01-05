import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqami/src/presentation/create_post/bloc/create_post_bloc.dart';
import 'package:raqami/src/presentation/ui/theme/raqami_theme.dart';
import 'package:raqami/src/presentation/ui/typography/raqami_text_style.dart';

class PlateNumberField extends StatelessWidget {
  final TextEditingController controller;

  const PlateNumberField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RaqamiTheme.of(context);

    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return SizedBox(
          height: 56,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            style: RaqamiTextStyles.bodyBaseRegular,
            keyboardType: TextInputType.number,
            maxLength: 5,
            decoration: InputDecoration(
              hintText: 'Number',
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
              counterText: '',
            ),
            onChanged: (value) {
              context.read<CreatePostBloc>().add(
                    CreatePostEvent.numberChanged(value),
                  );
            },
          ),
        );
      },
    );
  }
}

