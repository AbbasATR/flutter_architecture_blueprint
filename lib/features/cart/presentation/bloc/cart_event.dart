import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';

/// Base class for all cart events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load cart items from storage
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

/// Event to add item to cart
class AddToCartEvent extends CartEvent {
  final CartItem item;

  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to update cart item
class UpdateCartItemEvent extends CartEvent {
  final CartItem item;

  const UpdateCartItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to delete item from cart
class DeleteCartItemEvent extends CartEvent {
  final String id;

  const DeleteCartItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to increment item quantity
class IncrementQuantityEvent extends CartEvent {
  final String id;

  const IncrementQuantityEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to decrement item quantity
class DecrementQuantityEvent extends CartEvent {
  final String id;

  const DecrementQuantityEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to clear cart
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

/// Event to clear cart and add new item from different supplier
class ReplaceCartAndAddEvent extends CartEvent {
  final CartItem item;

  const ReplaceCartAndAddEvent(this.item);

  @override
  List<Object?> get props => [item];
}
