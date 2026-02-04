import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetUnreadCount useCase;
  late MockNotificationRepository mockNotificationRepository;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    useCase = GetUnreadCount(mockNotificationRepository);
  });

  group('GetUnreadCount', () {
    test('should call repository.getUnreadCount', () async {
      // arrange
      when(
        mockNotificationRepository.getUnreadCount(),
      ).thenAnswer((_) async => 5);

      // act
      await useCase();

      // assert
      verify(mockNotificationRepository.getUnreadCount());
      verifyNoMoreInteractions(mockNotificationRepository);
    });

    test('should return unread count when fetch is successful', () async {
      // arrange
      const tUnreadCount = 5;
      when(
        mockNotificationRepository.getUnreadCount(),
      ).thenAnswer((_) async => tUnreadCount);

      // act
      final result = await useCase();

      // assert
      expect(result, tUnreadCount);
    });

    test('should return 0 when no unread notifications', () async {
      // arrange
      when(
        mockNotificationRepository.getUnreadCount(),
      ).thenAnswer((_) async => 0);

      // act
      final result = await useCase();

      // assert
      expect(result, 0);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockNotificationRepository.getUnreadCount(),
      ).thenThrow(Exception('Network error'));

      // act & assert
      expect(() async => await useCase(), throwsA(isA<Exception>()));
      verify(mockNotificationRepository.getUnreadCount());
    });
  });
}
