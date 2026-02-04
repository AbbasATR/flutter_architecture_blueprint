import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> activeOrders;
  final List<Order> pastOrders;

  const OrderLoaded({required this.activeOrders, required this.pastOrders});

  @override
  List<Object?> get props => [activeOrders, pastOrders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderCreating extends OrderState {}

class OrderCreateSuccess extends OrderState {
  final Order order;

  const OrderCreateSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderCreateError extends OrderState {
  final String message;

  const OrderCreateError(this.message);

  @override
  List<Object?> get props => [message];
}
