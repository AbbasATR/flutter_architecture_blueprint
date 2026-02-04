import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget displaying empty cart state
class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconsaxPlusLinear.shopping_cart,
            size: context.units.sp(80),
            color: context.cs.onSurfaceVariant,
          ),
          SizedBox(height: context.units.h(16)),
          Text(
            context.l10n.cartEmpty,
            style: context.tt.titleLarge.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.units.h(8)),
          Text(
            context.l10n.cartEmptyMessage,
            style: context.tt.labelMedium.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
