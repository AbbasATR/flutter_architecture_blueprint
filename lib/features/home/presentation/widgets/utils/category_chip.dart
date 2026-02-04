import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class CategoryChip extends StatelessWidget {
  final String label; // localization key (e.g., 'jet', 'restaurants')
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  String _getLocalizedLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key.toLowerCase()) {
      case 'jet':
        return l10n.jet;
      case 'restaurants':
        return l10n.restaurants;
      case 'shopping':
        return l10n.shopping;
      case 'grocery':
        return l10n.grocery;
      case 'flowers':
        return l10n.flowers;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.units.w(isSelected ? 65 : 60);
    final localizedLabel = _getLocalizedLabel(context, label);
    final isDarkMode = context.isDark;

    // Determine the image path based on the category and theme
    String imagePath;
    if (label.toLowerCase() == 'jet') {
      imagePath = isDarkMode
          ? 'assets/images/logo/jet_white.png'
          : 'assets/images/logo/jet_black.png';
    } else {
      imagePath = 'assets/images/categories/${label.toLowerCase()}.png';
    }

    return Semantics(
      button: true,
      selected: isSelected,
      label: localizedLabel,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.units.w(0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.cs.surfaceContainer
                    : context.cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.cs.onSurface.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : const [],
              ),
              child: Padding(
                padding: EdgeInsets.all(context.units.w(isSelected ? 11 : 15)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox.shrink(), // safe fallback
                ),
              ),
            ),
            SizedBox(height: context.units.h(7)),
            Text(
              localizedLabel,
              style: isSelected
                  ? context.tt.titleMedium.copyWith(fontSize: 13)
                  : context.tt.labelMedium,
            ),
            SizedBox(height: context.units.h(3)),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: size,
              decoration: BoxDecoration(
                color: isSelected ? context.cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
