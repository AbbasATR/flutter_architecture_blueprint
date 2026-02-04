import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MarkAsRead useCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    useCase = MarkAsRead(mockNotificationRepository);
  });

  const tNotificationId = 'notification_123';

  group('MarkAsRead', () {
    test(
      'should call repository.markAsRead with correct notification id',
      () async {
        // arrange
        when(
          mockNotificationRepository.markAsRead(any),
        ).thenAnswer((_) async => Future.value());

        // act
        await useCase(tNotificationId);

        // assert
        verify(mockNotificationRepository.markAsRead(tNotificationId));
        verifyNoMoreInteractions(mockNotificationRepository);
      },
    );

    test('should complete successfully when marking as read', () async {
      // arrange
      when(
        mockNotificationRepository.markAsRead(any),
      ).thenAnswer((_) async => Future.value());

      // act & assert
      expect(() async => await useCase(tNotificationId), returnsNormally);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockNotificationRepository.markAsRead(any),
      ).thenThrow(Exception('Failed to mark as read'));

      // act & assert
      expect(
        () async => await useCase(tNotificationId),
        throwsA(isA<Exception>()),
      );
      verify(mockNotificationRepository.markAsRead(tNotificationId));
    });
  });
}
