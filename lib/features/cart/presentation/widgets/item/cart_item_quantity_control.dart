import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Quantity control widget with increment/decrement buttons
class CartItemQuantityControl extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemQuantityControl({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.secondary,
        borderRadius: BorderRadius.circular(context.units.r(7)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            context,
            icon: IconsaxPlusLinear.add,
            onTap: onIncrement,
            isIncrement: true,
          ),
          _buildControlButton(
            context,
            icon: IconsaxPlusLinear.minus,
            onTap: onDecrement,
            isIncrement: false,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required bool isIncrement,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.units.r(7)),
      child: Container(
        padding: EdgeInsets.all(context.units.w(3)),
        decoration: BoxDecoration(
          color: isIncrement ? context.cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(context.units.r(7)),
        ),
        child: Icon(
          icon,
          size: context.units.sp(20),
          color: isIncrement ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
