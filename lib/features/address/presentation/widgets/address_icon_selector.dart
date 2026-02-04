import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget for selecting address icon (home, work, other)
class AddressIconSelector extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;

  const AddressIconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.selectIcon,
          style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: context.units.h(12)),
        Row(
          children: [
            _IconOption(
              iconType: 'home',
              icon: IconsaxPlusLinear.home,
              label: context.l10n.homeAddress,
              isSelected: selectedIcon == 'home',
              onTap: () => onIconSelected('home'),
            ),
            SizedBox(width: context.units.w(16)),
            _IconOption(
              iconType: 'work',
              icon: IconsaxPlusLinear.briefcase,
              label: context.l10n.work,
              isSelected: selectedIcon == 'work',
              onTap: () => onIconSelected('work'),
            ),
            SizedBox(width: context.units.w(16)),
            _IconOption(
              iconType: 'location',
              icon: IconsaxPlusLinear.location,
              label: context.l10n.other,
              isSelected: selectedIcon == 'location',
              onTap: () => onIconSelected('location'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual icon option widget
class _IconOption extends StatelessWidget {
  final String iconType;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconOption({
    required this.iconType,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.units.h(12),
            horizontal: context.units.w(8),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? context.cs.primary.withValues(alpha: 0.1)
                : context.cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? context.cs.primary : context.cs.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? context.cs.primary : context.cs.onSurface,
                size: context.units.w(24),
              ),
              SizedBox(height: context.units.h(4)),
              Text(
                label,
                style: context.tt.labelMedium.copyWith(
                  color: context.cs.onSurface,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
