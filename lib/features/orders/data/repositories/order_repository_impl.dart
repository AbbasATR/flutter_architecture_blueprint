import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_architecture_blueprint/core/error/error_mapper.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required this.remoteDataSource});

  final OrderRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final models = await remoteDataSource.getOrders();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getActiveOrders() async {
    try {
      final models = await remoteDataSource.getOrders();
      final activeOrders = models
          .where((order) => order.isActive)
          .map((model) => model.toEntity())
          .toList();
      return Right(activeOrders);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getPastOrders() async {
    try {
      final models = await remoteDataSource.getOrders();
      final pastOrders = models
          .where((order) => !order.isActive)
          .map((model) => model.toEntity())
          .toList();
      return Right(pastOrders);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(int id) async {
    try {
      final model = await remoteDataSource.getOrderById(id);
      return Right(model.toEntity());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrder({
    required List<CartItem> cartItems,
    required String deliveryAddress,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double deliveryFee,
    String? notes,
  }) async {
    try {
      final model = await remoteDataSource.createOrder(
        cartItems: cartItems,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        notes: notes,
      );
      return Right(model.toEntity());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }
}
