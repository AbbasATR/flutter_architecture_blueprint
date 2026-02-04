import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/item/cart_item_details.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/item/cart_item_dismiss_background.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/item/cart_item_image.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/item/cart_item_quantity_control.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Widget for displaying a cart item card
class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cartItem.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) => onDelete(),
      background: const CartItemDismissBackground(
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: const CartItemDismissBackground(
        alignment: Alignment.centerRight,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: context.units.h(12)),
        padding: EdgeInsets.all(context.units.w(12)),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(context.units.r(12)),
          border:
              Border.all(color: context.cs.outline.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            CartItemImage(imageUrl: cartItem.item.imageURL),
            SizedBox(width: context.units.w(12)),
            Expanded(child: CartItemDetails(cartItem: cartItem)),
            SizedBox(width: context.units.w(8)),
            CartItemQuantityControl(
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ],
        ),
      ),
    );
  }
}
