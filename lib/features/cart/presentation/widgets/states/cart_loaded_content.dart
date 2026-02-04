import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/cart_items_list.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/cart_summary.dart';

/// Widget displaying loaded cart content (items list + summary)
class CartLoadedContent extends StatelessWidget {
  final List<CartItem> items;
  final double totalPrice;
  final VoidCallback onCheckout;

  const CartLoadedContent({
    super.key,
    required this.items,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: CartItemsList(items: items)),
        SafeArea(
          child: CartSummary(
            subtotal: totalPrice,
            total: totalPrice,
            onCheckout: onCheckout,
          ),
        ),
      ],
    );
  }
}
