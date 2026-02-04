import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/models/order_model.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

abstract class OrderRemoteDataSource {
  /// Gets all orders for the current user
  ///
  /// Throws [ServerException] for server errors
  /// Throws [NetworkException] for network errors
  Future<List<OrderModel>> getOrders();

  /// Gets a single order by ID
  ///
  /// Throws [ServerException] for server errors
  /// Throws [NetworkException] for network errors
  /// Throws [NotFoundException] if order not found
  Future<OrderModel> getOrderById(int orderId);

  /// Creates a new order
  ///
  /// Throws [ServerException] for server errors
  /// Throws [NetworkException] for network errors
  Future<OrderModel> createOrder(Map<String, dynamic> orderData);

  /// Cancels an order
  ///
  /// Throws [ServerException] for server errors
  /// Throws [NetworkException] for network errors
  /// Throws [NotFoundException] if order not found
  Future<void> cancelOrder(int orderId, String reason);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final bool useMockData; // Flag to use mock data temporarily

  OrderRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://api.example.com',
    this.useMockData = true, // Set to false when API is ready
  });

  @override
  Future<List<OrderModel>> getOrders() async {
    // Return mock data if API is not ready
    if (useMockData) {
      return Future.delayed(
        const Duration(milliseconds: 500),
        () => _getMockOrders(),
      );
    }

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/orders'),
        headers: {
          'Content-Type': 'application/json',

          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw ServerException('Unauthorized');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ServerException('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    // Return mock data if API is not ready
    if (useMockData) {
      return Future.delayed(const Duration(milliseconds: 300), () {
        final orders = _getMockOrders();
        try {
          return orders.firstWhere((order) => order.id == orderId);
        } catch (e) {
          throw NotFoundException('Order not found');
        }
      });
    }

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',

          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];
        return OrderModel.fromJson(json as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException('Order not found');
      } else if (response.statusCode == 401) {
        throw ServerException('Unauthorized');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ServerException('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {
          'Content-Type': 'application/json',

          // 'Authorization': 'Bearer $token',
        },
        body: json.encode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];
        return OrderModel.fromJson(json as Map<String, dynamic>);
      } else if (response.statusCode == 401) {
        throw ServerException('Unauthorized');
      } else if (response.statusCode == 400) {
        throw ServerException('Invalid order data');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ServerException('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> cancelOrder(int orderId, String reason) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/orders/$orderId/cancel'),
        headers: {
          'Content-Type': 'application/json',

          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({'reason': reason}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw NotFoundException('Order not found');
      } else if (response.statusCode == 401) {
        throw ServerException('Unauthorized');
      } else if (response.statusCode == 400) {
        throw ServerException('Cannot cancel order');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ServerException('Failed to cancel order: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException || e is NotFoundException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  /// Mock data for development/testing
  List<OrderModel> _getMockOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 1,
        timestamp: now.subtract(const Duration(hours: 2)),
        orderedById: 1,
        status: OrderStatus.onTheWay,
        cashPaid: 35000,
        pointsPaid: 0,
        isSettled: false,
        identifier: 'ORD-001',
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotalAmount: 30000,
        discountTotal: 0,
        deliveryFee: 5000,
        prepMinutes: 30,
        dropoffAddress: 'Baghdad, Al-Karrada, Street 52, Building 10',
        supplierName: 'TURATH RESTAURANT',
        supplierImage: 'assets/images/atr_restaurants/turath.png',
        driverId: 101,
        confirmedAt: now.subtract(const Duration(hours: 1, minutes: 50)),
        preparedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        pickedUpAt: now.subtract(const Duration(minutes: 45)),
        items: const [
          OrderItemModel(name: 'Chicken Mandi', quantity: 2, price: 15000),
          OrderItemModel(name: 'Dolma', quantity: 2, price: 7500),
        ],
      ),
      OrderModel(
        id: 2,
        timestamp: now.subtract(const Duration(hours: 5)),
        orderedById: 1,
        status: OrderStatus.processing,
        cashPaid: 29000,
        pointsPaid: 0,
        isSettled: false,
        identifier: 'ORD-002',
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotalAmount: 24000,
        discountTotal: 0,
        deliveryFee: 5000,
        prepMinutes: 25,
        dropoffAddress: 'Baghdad, Al-Mansour, Main Street',
        supplierName: 'FOOD FORD RESTAURANT',
        supplierImage: 'assets/images/atr_restaurants/food_fort.png',
        confirmedAt: now.subtract(const Duration(hours: 4, minutes: 55)),
        items: const [
          OrderItemModel(name: 'Beef Burger', quantity: 2, price: 12000),
        ],
      ),
      OrderModel(
        id: 3,
        timestamp: now.subtract(const Duration(days: 2)),
        orderedById: 1,
        status: OrderStatus.delivered,
        cashPaid: 45000,
        pointsPaid: 0,
        isSettled: true,
        identifier: 'ORD-003',
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotalAmount: 40000,
        discountTotal: 5000,
        deliveryFee: 5000,
        prepMinutes: 35,
        dropoffAddress: 'Baghdad, Al-Jadriya, University Street',
        supplierName: 'TURATH RESTAURANT',
        supplierImage: 'assets/images/atr_restaurants/turath.png',
        driverId: 102,
        confirmedAt: now.subtract(const Duration(days: 2, hours: -1)),
        preparedAt: now.subtract(
          const Duration(days: 2, hours: -1, minutes: -20),
        ),
        pickedUpAt: now.subtract(
          const Duration(days: 2, hours: -1, minutes: -40),
        ),
        deliveredAt: now.subtract(const Duration(days: 2, hours: -2)),
        items: const [
          OrderItemModel(name: 'Chicken Mandi', quantity: 2, price: 15000),
          OrderItemModel(name: 'Lamb Kebab', quantity: 1, price: 18000),
          OrderItemModel(name: 'Dolma', quantity: 2, price: 7000),
        ],
      ),
      OrderModel(
        id: 4,
        timestamp: now.subtract(const Duration(days: 5)),
        orderedById: 1,
        status: OrderStatus.delivered,
        cashPaid: 28000,
        pointsPaid: 0,
        isSettled: true,
        identifier: 'ORD-004',
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotalAmount: 23000,
        discountTotal: 0,
        deliveryFee: 5000,
        prepMinutes: 30,
        dropoffAddress: 'Baghdad, Al-Karrada, Street 52, Building 10',
        supplierName: 'FOOD FORD RESTAURANT',
        supplierImage: 'assets/images/atr_restaurants/food_fort.png',
        driverId: 103,
        confirmedAt: now.subtract(const Duration(days: 5, hours: -1)),
        preparedAt: now.subtract(
          const Duration(days: 5, hours: -1, minutes: -25),
        ),
        pickedUpAt: now.subtract(
          const Duration(days: 5, hours: -1, minutes: -45),
        ),
        deliveredAt: now.subtract(const Duration(days: 5, hours: -2)),
        items: const [
          OrderItemModel(name: 'Pizza Margherita', quantity: 1, price: 18000),
          OrderItemModel(name: 'French Fries', quantity: 2, price: 5000),
        ],
      ),
      OrderModel(
        id: 5,
        timestamp: now.subtract(const Duration(days: 7)),
        orderedById: 1,
        status: OrderStatus.canceled,
        cashPaid: 0,
        pointsPaid: 0,
        isSettled: false,
        identifier: 'ORD-005',
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotalAmount: 32000,
        discountTotal: 0,
        deliveryFee: 5000,
        prepMinutes: 30,
        dropoffAddress: 'Baghdad, Al-Mansour, Main Street',
        supplierName: 'TURATH RESTAURANT',
        supplierImage: 'assets/images/atr_restaurants/turath.png',
        items: const [
          OrderItemModel(name: 'Mixed Grill', quantity: 1, price: 25000),
          OrderItemModel(name: 'Hummus', quantity: 1, price: 7000),
        ],
      ),
    ];
  }
}
