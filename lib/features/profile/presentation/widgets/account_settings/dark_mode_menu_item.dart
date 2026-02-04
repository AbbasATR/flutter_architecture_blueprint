import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Dark mode toggle menu item with switch
class DarkModeMenuItem extends StatelessWidget {
  const DarkModeMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.dark_mode_outlined,
                size: 24,
                color: context.cs.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  context.l10n.darkMode,
                  style: context.tt.labelLarge.copyWith(
                    color: context.cs.onSurface,
                  ),
                ),
              ),
              Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeModeCubit>().setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
                thumbColor: WidgetStateProperty.all(
                  context.cs.secondary.withValues(alpha: 0.5),
                ),
                //  activeColor: context.cs.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
