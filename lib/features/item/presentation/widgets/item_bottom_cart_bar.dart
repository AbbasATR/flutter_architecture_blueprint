import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Bottom bar with quantity selector and add to cart button
class ItemBottomCartBar extends StatelessWidget {
  final int quantity;
  final double totalPrice;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const ItemBottomCartBar({
    super.key,
    required this.quantity,
    required this.totalPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(context.units.w(20)),
        decoration: BoxDecoration(
          color: context.cs.surfaceBright,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.units.r(25)),
          ),
          boxShadow: [
            BoxShadow(
              color: context.cs.onSurface.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTotalPrice(context),
            SizedBox(height: context.units.h(12)),
            Row(
              children: [
                _buildQuantitySelector(context),
                SizedBox(width: context.units.w(16)),
                _buildAddToCartButton(context, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPrice(BuildContext context) {
    return Text(
      '${totalPrice.toStringAsFixed(0)} IQD',
      style: context.tt.titleLarge.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surfaceContainer,
        borderRadius: BorderRadius.circular(context.units.r(6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            context,
            icon: IconsaxPlusLinear.minus,
            onPressed: quantity > 1 ? onDecrement : null,
          ),
          _buildQuantityDisplay(context),
          _buildQuantityButton(
            context,
            icon: IconsaxPlusLinear.add,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: context.units.w(32),
      height: context.units.h(32),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: context.units.sp(18),
        icon: Icon(icon, color: context.cs.onSurface),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildQuantityDisplay(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.units.w(12),
        vertical: context.units.h(6),
      ),
      decoration: BoxDecoration(color: context.cs.primary),
      child: Text(
        quantity.toString(),
        style: context.tt.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: context.cs.onPrimary,
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, dynamic l10n) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onAddToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: context.units.h(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.units.r(12)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: context.units.w(25)),
            Text(
              l10n.addToCart,
              style: context.tt.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: context.units.w(30)),
            Icon(
              IconsaxPlusLinear.shopping_cart,
              color: context.cs.primary,
              size: context.units.sp(20),
            ),
          ],
        ),
      ),
    );
  }
}
