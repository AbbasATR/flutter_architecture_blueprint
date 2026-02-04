import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget displaying cart item details (name, price, size)
class CartItemDetails extends StatelessWidget {
  final CartItem cartItem;

  const CartItemDetails({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemName(context),
        SizedBox(height: context.units.h(4)),
        _buildItemPrice(context),
        if (cartItem.selectedSize != null) ...[
          SizedBox(height: context.units.h(4)),
          _buildItemSize(context),
        ],
      ],
    );
  }

  Widget _buildItemName(BuildContext context) {
    return Text(
      cartItem.item.name,
      style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildItemPrice(BuildContext context) {
    return Row(
      children: [
        Text(
          '${cartItem.totalPrice.toStringAsFixed(0)} IQD',
          style: context.tt.labelLarge.copyWith(
            color: context.cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.units.w(12),
            vertical: context.units.h(4),
          ),
          child: Text(
            'x${cartItem.quantity}',
            style: context.tt.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildItemSize(BuildContext context) {
    return Text(
      '${context.l10n.size}: ${cartItem.selectedSize}',
      style: context.tt.labelMedium.copyWith(
        color: context.cs.onSurfaceVariant,
      ),
    );
  }
}
