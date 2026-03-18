import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/models/order_model.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(int orderId);
  Future<OrderModel> createOrder({
    required List<CartItem> cartItems,
    required String deliveryAddress,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double deliveryFee,
    String? notes,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await dioClient.get(ApiEndpoints.orders);
      final payload = response.data;
      final jsonList = payload is Map<String, dynamic>
          ? (payload['data'] as List<dynamic>? ?? const <dynamic>[])
          : (payload as List<dynamic>? ?? const <dynamic>[]);
      return jsonList
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    try {
      final response = await dioClient.get('${ApiEndpoints.orders}/$orderId');
      final payload = response.data as Map<String, dynamic>;
      final data = payload['data'] as Map<String, dynamic>? ?? payload;
      return OrderModel.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<OrderModel> createOrder({
    required List<CartItem> cartItems,
    required String deliveryAddress,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double deliveryFee,
    String? notes,
  }) async {
    final body = {
      'delivery_address': deliveryAddress,
      'payment_method': paymentMethod.name,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'notes': notes,
      'items': cartItems
          .map(
            (item) => {
              'item_id': item.item.id,
              'name': item.item.name,
              'quantity': item.quantity,
              'unit_price': item.totalPrice / item.quantity,
              'selected_size': item.selectedSize,
              'special_instructions': item.specialInstructions,
            },
          )
          .toList(),
    };

    try {
      final response = await dioClient.post(ApiEndpoints.orders, data: body);
      final payload = response.data;
      if (payload is Map<String, dynamic>) {
        final data = payload['data'];
        if (data is Map<String, dynamic>) {
          return OrderModel.fromJson(data);
        }
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }

    throw ServerException('Invalid order response payload');
  }

  Exception _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return UnauthorizedException('Unauthorized');
    }
    if (statusCode == 404) {
      return NotFoundException('Order not found');
    }
    if (statusCode == 400) {
      return ValidationException('Invalid order request');
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkException(error.message ?? 'Network error');
    }
    return ServerException(error.message ?? 'Unexpected server error');
  }
}
