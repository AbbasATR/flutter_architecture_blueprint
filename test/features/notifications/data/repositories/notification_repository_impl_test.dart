import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/notifications/data/models/notification_model.dart';
import 'package:flutter_architecture_blueprint/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late NotificationRepositoryImpl repository;
  late MockNotificationLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockNotificationLocalDataSource();
    repository = NotificationRepositoryImpl(mockLocalDataSource);
  });

  final tNotification1 = NotificationModel(
    id: '1',
    title: 'Test Notification 1',
    message: 'Message 1',
    timestamp: DateTime(2024, 1, 1),
    isRead: false,
    type: NotificationType.general,
  );

  final tNotification2 = NotificationModel(
    id: '2',
    title: 'Test Notification 2',
    message: 'Message 2',
    timestamp: DateTime(2024, 1, 2),
    isRead: true,
    type: NotificationType.order,
  );

  final tNotifications = [tNotification1, tNotification2];

  group('getNotifications', () {
    test(
      'should return list of notifications from local data source',
      () async {
        // Arrange
        when(
          mockLocalDataSource.getNotifications(),
        ).thenAnswer((_) async => tNotifications);

        // Act
        final result = await repository.getNotifications();

        // Assert
        expect(result, equals(tNotifications));
        verify(mockLocalDataSource.getNotifications());
      },
    );

    test('should return empty list when no notifications', () async {
      // Arrange
      when(mockLocalDataSource.getNotifications()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getNotifications();

      // Assert
      expect(result, isEmpty);
      verify(mockLocalDataSource.getNotifications());
    });
  });

  group('getUnreadCount', () {
    test('should return unread count from local data source', () async {
      // Arrange
      when(mockLocalDataSource.getUnreadCount()).thenAnswer((_) async => 5);

      // Act
      final result = await repository.getUnreadCount();

      // Assert
      expect(result, equals(5));
      verify(mockLocalDataSource.getUnreadCount());
    });

    test('should return 0 when no unread notifications', () async {
      // Arrange
      when(mockLocalDataSource.getUnreadCount()).thenAnswer((_) async => 0);

      // Act
      final result = await repository.getUnreadCount();

      // Assert
      expect(result, equals(0));
      verify(mockLocalDataSource.getUnreadCount());
    });
  });

  group('markAsRead', () {
    test('should call local data source markAsRead', () async {
      // Arrange
      const tNotificationId = '1';
      when(
        mockLocalDataSource.markAsRead(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.markAsRead(tNotificationId);

      // Assert
      verify(mockLocalDataSource.markAsRead(tNotificationId));
    });
  });

  group('markAllAsRead', () {
    test('should call local data source markAllAsRead', () async {
      // Arrange
      when(
        mockLocalDataSource.markAllAsRead(),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.markAllAsRead();

      // Assert
      verify(mockLocalDataSource.markAllAsRead());
    });
  });

  group('deleteNotification', () {
    test('should call local data source deleteNotification', () async {
      // Arrange
      const tNotificationId = '1';
      when(
        mockLocalDataSource.deleteNotification(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.deleteNotification(tNotificationId);

      // Assert
      verify(mockLocalDataSource.deleteNotification(tNotificationId));
    });
  });

  group('clearAll', () {
    test('should call local data source clearAll', () async {
      // Arrange
      when(
        mockLocalDataSource.clearAll(),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.clearAll();

      // Assert
      verify(mockLocalDataSource.clearAll());
    });
  });
}
