import 'package:flutter_architecture_blueprint/features/notifications/data/models/notification_model.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAll();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  // In-memory storage for demo - replace with actual local storage
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Order Delivered',
      message: 'Your order #1234 has been delivered successfully',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.order,
      imageUrl: null,
    ),
    NotificationModel(
      id: '2',
      title: '20% Off on First Order',
      message: 'Get 20% discount on your first order. Use code: FIRST20',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      type: NotificationType.promotion,
      imageUrl: null,
    ),
    NotificationModel(
      id: '3',
      title: 'New Restaurant Added',
      message: 'Check out Alakrakchy Restaurant - Now available in your area',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.general,
      imageUrl: null,
    ),
    NotificationModel(
      id: '4',
      title: 'Order Confirmed',
      message: 'Your order #1233 has been confirmed and is being prepared',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
      type: NotificationType.order,
      imageUrl: null,
    ),
    NotificationModel(
      id: '5',
      title: 'Flash Sale Alert',
      message: 'Flash sale on selected items. Up to 50% off for limited time',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.promotion,
      imageUrl: null,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Sort by timestamp, newest first
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return List.from(_notifications);
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notifications.where((n) => !n.isRead).length;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<void> clearAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.clear();
  }
}
