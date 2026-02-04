import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orders = await remoteDataSource.getOrders();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Failed to load orders'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getActiveOrders() async {
    try {
      final orders = await remoteDataSource.getOrders();
      final activeOrders = orders.where((order) => order.isActive).toList();
      return Right(activeOrders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Failed to load active orders'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getPastOrders() async {
    try {
      final orders = await remoteDataSource.getOrders();
      final pastOrders = orders.where((order) => !order.isActive).toList();
      return Right(pastOrders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Failed to load past orders'));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(int id) async {
    try {
      final order = await remoteDataSource.getOrderById(id);
      return Right(order);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Failed to load order'));
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
      // For now, create a mock order since we don't have the data source method
      final now = DateTime.now();
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch,
        timestamp: now,
        orderedById: 1, // Mock user ID
        status: OrderStatus.ordered,
        cashPaid: paymentMethod == PaymentMethod.cashOnDelivery
            ? subtotal + deliveryFee
            : 0,
        pointsPaid: 0,
        isSettled: false,
        clientNotes: notes,
        identifier: 'JET${now.millisecondsSinceEpoch}',
        paymentMethod: paymentMethod,
        subtotalAmount: subtotal,
        discountTotal: 0,
        deliveryFee: deliveryFee,
        prepMinutes: 30,
        dropoffAddress: deliveryAddress,
        supplierName: cartItems.isNotEmpty
            ? 'Supplier ${cartItems.first.item.supplierId}'
            : 'Unknown Supplier',
        items: cartItems
            .map(
              (cartItem) => OrderItem(
                name: cartItem.item.name,
                quantity: cartItem.quantity,
                price: cartItem.totalPrice,
              ),
            )
            .toList(),
      );

      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure('Failed to create order'));
    }
  }
}
