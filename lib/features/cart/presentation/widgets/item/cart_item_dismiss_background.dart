import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Background widget shown when dismissing cart item
class CartItemDismissBackground extends StatelessWidget {
  final Alignment alignment;

  const CartItemDismissBackground({super.key, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.units.h(12)),
      padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
      decoration: BoxDecoration(
        color: context.cs.error,
        borderRadius: BorderRadius.circular(context.units.r(12)),
      ),
      alignment: alignment,
      child: Icon(
        IconsaxPlusBold.trash,
        color: Colors.white,
        size: context.units.sp(24),
      ),
    );
  }
}
