import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_all_as_read.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MarkAllAsRead useCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    useCase = MarkAllAsRead(mockNotificationRepository);
  });

  group('MarkAllAsRead', () {
    test('should call repository.markAllAsRead', () async {
      // arrange
      when(
        mockNotificationRepository.markAllAsRead(),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase();

      // assert
      verify(mockNotificationRepository.markAllAsRead());
      verifyNoMoreInteractions(mockNotificationRepository);
    });

    test('should complete successfully when marking all as read', () async {
      // arrange
      when(
        mockNotificationRepository.markAllAsRead(),
      ).thenAnswer((_) async => Future.value());

      // act & assert
      expect(() async => await useCase(), returnsNormally);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockNotificationRepository.markAllAsRead(),
      ).thenThrow(Exception('Failed to mark all as read'));

      // act & assert
      expect(() async => await useCase(), throwsA(isA<Exception>()));
      verify(mockNotificationRepository.markAllAsRead());
    });
  });
}
