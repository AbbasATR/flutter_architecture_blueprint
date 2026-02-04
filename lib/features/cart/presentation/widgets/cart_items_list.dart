import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/item/cart_item_card.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Widget displaying list of cart items
class CartItemsList extends StatelessWidget {
  final List<CartItem> items;

  const CartItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(context.units.w(16)),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cartItem = items[index];
        return CartItemCard(
          cartItem: cartItem,
          onIncrement: () {
            context.read<CartBloc>().add(IncrementQuantityEvent(cartItem.id));
          },
          onDecrement: () {
            context.read<CartBloc>().add(DecrementQuantityEvent(cartItem.id));
          },
          onDelete: () {
            context.read<CartBloc>().add(DeleteCartItemEvent(cartItem.id));
          },
        );
      },
    );
  }
}
