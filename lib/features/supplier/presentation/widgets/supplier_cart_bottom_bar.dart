import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Bottom navigation bar with cart button and view cart action.
class SupplierCartBottomBar extends StatelessWidget {
  final int itemCount;
  final String totalPrice;
  final String subtotalPrice;
  final VoidCallback onViewCartTap;

  const SupplierCartBottomBar({
    super.key,
    required this.itemCount,
    required this.totalPrice,
    required this.subtotalPrice,
    required this.onViewCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(context.units.w(10)),
        decoration: BoxDecoration(
          color: context.cs.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _ViewCartButton(
          totalPrice: totalPrice,
          subtotalPrice: subtotalPrice,
          onTap: onViewCartTap,
          itemCount: itemCount,
        ),
      ),
    );
  }
}

/// View cart button with price information.
class _ViewCartButton extends StatelessWidget {
  final String totalPrice;
  final String subtotalPrice;
  final VoidCallback onTap;
  final int itemCount;

  const _ViewCartButton({
    required this.totalPrice,
    required this.subtotalPrice,
    required this.onTap,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.cs.secondary,

        padding: EdgeInsets.symmetric(vertical: context.units.h(8)),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.units.r(12)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CartIconWithBadge(itemCount: itemCount),
          Text(context.l10n.viewCart, style: context.tt.buttonText),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(totalPrice, style: context.tt.buttonText),
                Text(
                  subtotalPrice,
                  style: context.tt.subTitleLarge.copyWith(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: context.cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cart icon with item count badge.
class _CartIconWithBadge extends StatelessWidget {
  final int itemCount;

  const _CartIconWithBadge({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.units.w(50),
      height: context.units.h(50),
      margin: EdgeInsets.symmetric(horizontal: context.units.w(8)),
      decoration: BoxDecoration(
        color: context.cs.primary,
        borderRadius: BorderRadius.circular(context.units.r(12)),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              IconsaxPlusBold.shopping_cart,
              color: context.cs.onPrimary,
              size: context.units.sp(28),
            ),
          ),
          if (itemCount > 0)
            Positioned(
              top: context.units.h(8),
              right: context.units.w(8),
              child: Container(
                width: context.units.w(18),
                height: context.units.w(18),
                decoration: BoxDecoration(
                  color: context.cs.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    itemCount.toString(),
                    style: context.tt.buttonText.copyWith(
                      fontSize: context.units.sp(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
