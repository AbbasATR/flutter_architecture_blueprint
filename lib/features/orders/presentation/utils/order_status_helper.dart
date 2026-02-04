import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

/// Helper class for order status display properties
class OrderStatusHelper {
  /// Get the color associated with an order status
  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.ordered:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.readyForPickup:
        return Colors.purple;
      case OrderStatus.onTheWay:
        return Colors.teal;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.canceled:
        return Colors.red;
    }
  }

  /// Get the icon associated with an order status
  static IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.ordered:
        return IconsaxPlusLinear.note_text;
      case OrderStatus.processing:
        return IconsaxPlusLinear.timer_1;
      case OrderStatus.readyForPickup:
        return IconsaxPlusLinear.bag_tick;
      case OrderStatus.onTheWay:
        return IconsaxPlusLinear.truck_fast;
      case OrderStatus.delivered:
        return IconsaxPlusLinear.tick_circle;
      case OrderStatus.canceled:
        return IconsaxPlusLinear.close_circle;
    }
  }

  /// Get the localization key for an order status
  static String getStatusKey(OrderStatus status) {
    switch (status) {
      case OrderStatus.ordered:
        return 'orderStatusOrdered';
      case OrderStatus.processing:
        return 'orderStatusProcessing';
      case OrderStatus.readyForPickup:
        return 'orderStatusReadyForPickup';
      case OrderStatus.onTheWay:
        return 'orderStatusOnTheWay';
      case OrderStatus.delivered:
        return 'orderStatusDelivered';
      case OrderStatus.canceled:
        return 'orderStatusCanceled';
    }
  }
}
