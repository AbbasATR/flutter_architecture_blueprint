import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';

class CreateOrder implements UseCase<Order, CreateOrderParams> {
  const CreateOrder(this.repository);

  final OrderRepository repository;

  @override
  Future<Either<Failure, Order>> call(CreateOrderParams params) {
    return repository.createOrder(
      cartItems: params.cartItems,
      deliveryAddress: params.deliveryAddress,
      paymentMethod: params.paymentMethod,
      subtotal: params.subtotal,
      deliveryFee: params.deliveryFee,
      notes: params.notes,
    );
  }
}

class CreateOrderParams extends Equatable {
  const CreateOrderParams({
    required this.cartItems,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    this.notes,
  });

  final List<CartItem> cartItems;
  final String deliveryAddress;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final String? notes;

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
