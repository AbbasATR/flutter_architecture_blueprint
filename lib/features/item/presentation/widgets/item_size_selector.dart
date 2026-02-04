import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget for selecting item size with pricing options
class ItemSizeSelector extends StatelessWidget {
  final String? selectedSize;
  final Map<String, double> sizeOptions;
  final ValueChanged<String> onSizeSelected;
  final Set<String> unavailableSizes;

  const ItemSizeSelector({
    super.key,
    required this.selectedSize,
    required this.sizeOptions,
    required this.onSizeSelected,
    this.unavailableSizes = const {},
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(context.units.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chooseSize,
            style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: context.units.h(12)),
          ...sizeOptions.entries.map((entry) {
            final isSelected = selectedSize == entry.key;
            final isAvailable = !unavailableSizes.contains(entry.key);

            return _buildSizeOption(
              context,
              l10n,
              entry,
              isSelected,
              isAvailable,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSizeOption(
    BuildContext context,
    dynamic l10n,
    MapEntry<String, double> entry,
    bool isSelected,
    bool isAvailable,
  ) {
    return GestureDetector(
      onTap: isAvailable ? () => onSizeSelected(entry.key) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: context.units.h(12)),
        padding: EdgeInsets.all(context.units.w(16)),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? context.cs.primary
                : context.cs.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(context.units.r(12)),
        ),
        child: Row(
          children: [
            _buildSelectionIcon(context, isSelected, isAvailable),
            SizedBox(width: context.units.w(12)),
            Expanded(
              child: Text(
                entry.key,
                style: context.tt.labelLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isAvailable
                      ? context.cs.onSurface
                      : context.cs.tertiary,
                ),
              ),
            ),
            if (!isAvailable) ...[
              SizedBox(width: context.units.w(8)),
              Text(
                l10n.notAvailable,
                style: context.tt.labelMedium.copyWith(color: context.cs.error),
              ),
            ],
            if (entry.value > 0)
              Text(
                '  + ${entry.value.toStringAsFixed(0)} IQD',
                style: context.tt.labelMedium.copyWith(
                  color: isAvailable
                      ? context.cs.onSurface
                      : context.cs.tertiary,
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIcon(
    BuildContext context,
    bool isSelected,
    bool isAvailable,
  ) {
    return Icon(
      isSelected ? IconsaxPlusBold.record_circle : IconsaxPlusLinear.record,
      color: isSelected
          ? context.cs.primary
          : isAvailable
          ? context.cs.onSurfaceVariant
          : context.cs.tertiary,
      size: context.units.sp(20),
    );
  }
}
