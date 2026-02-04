import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNotifications useCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    useCase = GetNotifications(mockNotificationRepository);
  });

  final tNotification = Notification(
    id: '1',
    title: 'Test Notification',
    message: 'This is a test notification',
    timestamp: DateTime(2024, 1, 1),
    isRead: false,
    type: NotificationType.general,
  );

  final tNotificationList = [tNotification];

  group('GetNotifications', () {
    test('should call repository.getNotifications', () async {
      // arrange
      when(
        mockNotificationRepository.getNotifications(),
      ).thenAnswer((_) async => tNotificationList);

      // act
      await useCase();

      // assert
      verify(mockNotificationRepository.getNotifications());
      verifyNoMoreInteractions(mockNotificationRepository);
    });

    test(
      'should return list of notifications when fetch is successful',
      () async {
        // arrange
        when(
          mockNotificationRepository.getNotifications(),
        ).thenAnswer((_) async => tNotificationList);

        // act
        final result = await useCase();

        // assert
        expect(result, tNotificationList);
        expect(result.length, 1);
        expect(result.first.id, '1');
        expect(result.first.title, 'Test Notification');
        expect(result.first.isRead, false);
      },
    );

    test(
      'should return empty list when no notifications are available',
      () async {
        // arrange
        when(
          mockNotificationRepository.getNotifications(),
        ).thenAnswer((_) async => []);

        // act
        final result = await useCase();

        // assert
        expect(result, isEmpty);
      },
    );

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockNotificationRepository.getNotifications(),
      ).thenThrow(Exception('Network error'));

      // act & assert
      expect(() async => await useCase(), throwsA(isA<Exception>()));
      verify(mockNotificationRepository.getNotifications());
    });
  });
}
