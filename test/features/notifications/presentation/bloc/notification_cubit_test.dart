import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late NotificationCubit notificationCubit;
  late MockGetNotifications mockGetNotifications;
  late MockGetUnreadCount mockGetUnreadCount;
  late MockMarkAsRead mockMarkAsRead;
  late MockMarkAllAsRead mockMarkAllAsRead;

  setUp(() {
    mockGetNotifications = MockGetNotifications();
    mockGetUnreadCount = MockGetUnreadCount();
    mockMarkAsRead = MockMarkAsRead();
    mockMarkAllAsRead = MockMarkAllAsRead();
    notificationCubit = NotificationCubit(
      getNotifications: mockGetNotifications,
      getUnreadCount: mockGetUnreadCount,
      markAsRead: mockMarkAsRead,
      markAllAsRead: mockMarkAllAsRead,
    );
  });

  tearDown(() {
    notificationCubit.close();
  });

  final tNotifications = [
    Notification(
      id: '1',
      title: 'Test Notification 1',
      message: 'This is test notification 1',
      timestamp: DateTime(2024, 1, 1),
      isRead: false,
      type: NotificationType.general,
    ),
    Notification(
      id: '2',
      title: 'Test Notification 2',
      message: 'This is test notification 2',
      timestamp: DateTime(2024, 1, 2),
      isRead: true,
      type: NotificationType.order,
    ),
    Notification(
      id: '3',
      title: 'Test Notification 3',
      message: 'This is test notification 3',
      timestamp: DateTime(2024, 1, 3),
      isRead: false,
      type: NotificationType.promotion,
    ),
  ];
  const tUnreadCount = 2;

  test('initial state should be NotificationInitial', () {
    expect(notificationCubit.state, equals(NotificationInitial()));
  });

  group('loadNotifications', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit [Loading, Loaded] when loading notifications succeeds',
      build: () {
        when(mockGetNotifications()).thenAnswer((_) async => tNotifications);
        when(mockGetUnreadCount()).thenAnswer((_) async => tUnreadCount);
        return notificationCubit;
      },
      act: (cubit) => cubit.loadNotifications(),
      expect: () => [
        NotificationLoading(),
        NotificationLoaded(
          notifications: tNotifications,
          unreadCount: tUnreadCount,
        ),
      ],
      verify: (_) {
        verify(mockGetNotifications()).called(1);
        verify(mockGetUnreadCount()).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit [Loading, Error] when loading notifications fails',
      build: () {
        when(mockGetNotifications()).thenThrow(Exception('Failed to load'));
        return notificationCubit;
      },
      act: (cubit) => cubit.loadNotifications(),
      expect: () => [
        NotificationLoading(),
        isA<NotificationError>().having(
          (e) => e.message,
          'message',
          contains('Failed to load'),
        ),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit [Loading, Error] when getting unread count fails',
      build: () {
        when(mockGetNotifications()).thenAnswer((_) async => tNotifications);
        when(mockGetUnreadCount()).thenThrow(Exception('Count failed'));
        return notificationCubit;
      },
      act: (cubit) => cubit.loadNotifications(),
      expect: () => [
        NotificationLoading(),
        isA<NotificationError>().having(
          (e) => e.message,
          'message',
          contains('Count failed'),
        ),
      ],
    );
  });

  group('markNotificationAsRead', () {
    blocTest<NotificationCubit, NotificationState>(
      'should update notification and emit new state when marking as read succeeds',
      build: () {
        when(mockMarkAsRead(any)).thenAnswer((_) async => Future.value());
        when(mockGetUnreadCount()).thenAnswer((_) async => 1);
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.markNotificationAsRead('1'),
      expect: () => [
        isA<NotificationLoaded>()
            .having(
              (state) =>
                  state.notifications.firstWhere((n) => n.id == '1').isRead,
              'first notification isRead',
              true,
            )
            .having((state) => state.unreadCount, 'unreadCount', 1),
      ],
      verify: (_) {
        verify(mockMarkAsRead('1')).called(1);
        verify(mockGetUnreadCount()).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit Error when marking as read fails',
      build: () {
        when(mockMarkAsRead(any)).thenThrow(Exception('Mark failed'));
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.markNotificationAsRead('1'),
      expect: () => [
        isA<NotificationError>().having(
          (e) => e.message,
          'message',
          contains('Mark failed'),
        ),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'should not emit when state is not NotificationLoaded',
      build: () => notificationCubit,
      seed: () => NotificationInitial(),
      act: (cubit) => cubit.markNotificationAsRead('1'),
      expect: () => [],
      verify: (_) {
        verifyNever(mockMarkAsRead(any));
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should keep other notifications unchanged when marking one as read',
      build: () {
        when(mockMarkAsRead(any)).thenAnswer((_) async => Future.value());
        when(mockGetUnreadCount()).thenAnswer((_) async => 1);
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.markNotificationAsRead('1'),
      expect: () => [
        isA<NotificationLoaded>()
            .having(
              (state) =>
                  state.notifications.firstWhere((n) => n.id == '2').isRead,
              'second notification unchanged',
              true,
            )
            .having(
              (state) =>
                  state.notifications.firstWhere((n) => n.id == '3').isRead,
              'third notification unchanged',
              false,
            ),
      ],
    );
  });

  group('markAllNotificationsAsRead', () {
    blocTest<NotificationCubit, NotificationState>(
      'should mark all notifications as read and set unread count to 0',
      build: () {
        when(mockMarkAllAsRead()).thenAnswer((_) async => Future.value());
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.markAllNotificationsAsRead(),
      expect: () => [
        isA<NotificationLoaded>()
            .having(
              (state) => state.notifications.every((n) => n.isRead),
              'all notifications are read',
              true,
            )
            .having((state) => state.unreadCount, 'unreadCount is 0', 0),
      ],
      verify: (_) {
        verify(mockMarkAllAsRead()).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit Error when marking all as read fails',
      build: () {
        when(mockMarkAllAsRead()).thenThrow(Exception('Mark all failed'));
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.markAllNotificationsAsRead(),
      expect: () => [
        isA<NotificationError>().having(
          (e) => e.message,
          'message',
          contains('Mark all failed'),
        ),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'should not emit when state is not NotificationLoaded',
      build: () => notificationCubit,
      seed: () => NotificationInitial(),
      act: (cubit) => cubit.markAllNotificationsAsRead(),
      expect: () => [],
      verify: (_) {
        verifyNever(mockMarkAllAsRead());
      },
    );
  });

  group('refreshUnreadCount', () {
    blocTest<NotificationCubit, NotificationState>(
      'should update unread count without changing notifications',
      build: () {
        when(mockGetUnreadCount()).thenAnswer((_) async => 5);
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.refreshUnreadCount(),
      expect: () => [
        isA<NotificationLoaded>()
            .having(
              (state) => state.notifications,
              'notifications unchanged',
              tNotifications,
            )
            .having((state) => state.unreadCount, 'unreadCount updated', 5),
      ],
      verify: (_) {
        verify(mockGetUnreadCount()).called(1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should silently fail when getting unread count fails',
      build: () {
        when(mockGetUnreadCount()).thenThrow(Exception('Failed'));
        return notificationCubit;
      },
      seed: () => NotificationLoaded(
        notifications: tNotifications,
        unreadCount: tUnreadCount,
      ),
      act: (cubit) => cubit.refreshUnreadCount(),
      expect: () => [],
    );

    blocTest<NotificationCubit, NotificationState>(
      'should not emit when state is not NotificationLoaded',
      build: () {
        when(mockGetUnreadCount()).thenAnswer((_) async => 5);
        return notificationCubit;
      },
      seed: () => NotificationInitial(),
      act: (cubit) => cubit.refreshUnreadCount(),
      expect: () => [],
    );
  });
}
