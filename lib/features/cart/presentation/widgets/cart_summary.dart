import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

/// Widget for displaying cart summary with prices and checkout button
class CartSummary extends StatelessWidget {
  final double subtotal;
  final double total;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(context.units.w(20)),
      margin: EdgeInsets.only(
        bottom: context.units.h(10),
        left: context.units.w(10),
        right: context.units.w(10),
      ),
      decoration: BoxDecoration(
        color: context.cs.surfaceBright,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.units.r(25)),
          bottom: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: context.cs.onSurface.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPricingRow(
            context,
            label: subtotal.toStringAsFixed(0),
            value: total.toStringAsFixed(0),
            isTotal: false,
          ),
          SizedBox(height: context.units.h(16)),
          SubmitButton(
            text: l10n.checkout,
            icon: IconsaxPlusLinear.card_pos,
            onPressed: onCheckout,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Text(
      '$value IQD',
      style: isTotal
          ? context.tt.titleLarge.copyWith(fontWeight: FontWeight.bold)
          : context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
