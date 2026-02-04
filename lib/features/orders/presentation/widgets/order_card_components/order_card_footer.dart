import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Footer section showing total amount and view details button
class OrderCardFooter extends StatelessWidget {
  final double totalAmount;

  const OrderCardFooter({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priceColor = isDark ? context.cs.primary : context.cs.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.totalAmount,
                style: context.tt.labelMedium.copyWith(
                  color: context.cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${totalAmount.toStringAsFixed(0)} IQD',
                style: context.tt.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: priceColor,
                ),
              ),
            ],
          ),
          // View details button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.viewDetails,
                  style: context.tt.buttonText.copyWith(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  size: 16,
                  color: context.cs.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
