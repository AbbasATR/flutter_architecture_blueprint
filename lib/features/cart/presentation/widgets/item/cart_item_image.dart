import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Image widget for cart item
class CartItemImage extends StatelessWidget {
  final String imageUrl;

  const CartItemImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.units.r(8)),
      child: Image.asset(
        imageUrl,
        width: context.units.w(60),
        height: context.units.h(60),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: context.units.w(60),
            height: context.units.h(60),
            color: context.cs.surfaceContainerHighest,
            child: Icon(
              IconsaxPlusLinear.gallery,
              color: context.cs.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }
}
