import 'package:flutter_architecture_blueprint/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl(this.localDataSource);

  @override
  Future<List<Notification>> getNotifications() async {
    return await localDataSource.getNotifications();
  }

  @override
  Future<int> getUnreadCount() async {
    return await localDataSource.getUnreadCount();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await localDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    await localDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await localDataSource.deleteNotification(notificationId);
  }

  @override
  Future<void> clearAll() async {
    await localDataSource.clearAll();
  }
}
