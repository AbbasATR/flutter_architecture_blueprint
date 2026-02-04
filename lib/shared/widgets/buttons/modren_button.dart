import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';

class ModrenButton extends StatelessWidget {
  final String addText;
  final VoidCallback onPressed;
  final IconData? icon;
  const ModrenButton({
    super.key,
    required this.addText,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeModeCubit>().isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 50,
        child: ActionChip(
          label: Text(addText),
          avatar: icon != null ? Icon(icon, size: 20) : null,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
