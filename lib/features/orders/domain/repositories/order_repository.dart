import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, List<Order>>> getActiveOrders();
  Future<Either<Failure, List<Order>>> getPastOrders();
  Future<Either<Failure, Order>> getOrderById(int id);
  Future<Either<Failure, Order>> createOrder({
    required List<CartItem> cartItems,
    required String deliveryAddress,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double deliveryFee,
    String? notes,
  });
}
