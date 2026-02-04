import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {}

class LoadActiveOrdersEvent extends OrderEvent {}

class LoadPastOrdersEvent extends OrderEvent {}

class RefreshOrdersEvent extends OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final List<CartItem> cartItems;
  final String deliveryAddress;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final String? notes;

  const CreateOrderEvent({
    required this.cartItems,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    this.notes,
  });

  @override
  List<Object?> get props => [
    cartItems,
    deliveryAddress,
    paymentMethod,
    subtotal,
    deliveryFee,
    notes,
  ];
}
