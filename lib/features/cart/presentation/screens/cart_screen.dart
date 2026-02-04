import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/screens/checkout_screen.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/cart_app_bar.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/states/cart_empty_state.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/states/cart_error_state.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/states/cart_loaded_content.dart';

/// Main cart screen displaying shopping cart items
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CartAppBar(),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return CartErrorState(message: state.message);
          }

          if (state is CartLoaded || state is CartOperationSuccess) {
            final items = state is CartLoaded
                ? state.items
                : (state as CartOperationSuccess).items;
            final totalPrice = state is CartLoaded
                ? state.totalPrice
                : (state as CartOperationSuccess).totalPrice;

            if (items.isEmpty) {
              return const CartEmptyState();
            }

            return CartLoadedContent(
              items: items,
              totalPrice: totalPrice,
              onCheckout: () => _handleCheckout(context, items, totalPrice),
            );
          }

          return const CartEmptyState();
        },
      ),
    );
  }

  void _handleCheckout(BuildContext context, items, totalPrice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CheckoutScreen(cartItems: items, subtotal: totalPrice),
      ),
    );
  }
}
