import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';

/// Base class for all cart states
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CartInitial extends CartState {
  const CartInitial();
}

/// Loading state
class CartLoading extends CartState {
  const CartLoading();
}

/// Loaded state with cart items
class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;
  final int totalItems;

  const CartLoaded({
    required this.items,
    required this.totalPrice,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [items, totalPrice, totalItems];

  CartLoaded copyWith({
    List<CartItem>? items,
    double? totalPrice,
    int? totalItems,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

/// Error state
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state for operations (add, update, delete)
class CartOperationSuccess extends CartState {
  final String message;
  final List<CartItem> items;
  final double totalPrice;
  final int totalItems;

  const CartOperationSuccess({
    required this.message,
    required this.items,
    required this.totalPrice,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [message, items, totalPrice, totalItems];
}
