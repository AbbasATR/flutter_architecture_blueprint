import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/select_address.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SelectAddress useCase;
  late MockAddressRepository mockAddressRepository;

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    useCase = SelectAddress(mockAddressRepository);
  });

  const tAddressId = 'address_123';

  group('SelectAddress', () {
    test(
      'should call repository.selectAddress with correct address id',
      () async {
        // arrange
        when(
          mockAddressRepository.selectAddress(any),
        ).thenAnswer((_) async => Future.value());

        // act
        await useCase(tAddressId);

        // assert
        verify(mockAddressRepository.selectAddress(tAddressId));
        verifyNoMoreInteractions(mockAddressRepository);
      },
    );

    test('should complete successfully when selecting address', () async {
      // arrange
      when(
        mockAddressRepository.selectAddress(any),
      ).thenAnswer((_) async => Future.value());

      // act & assert
      expect(() async => await useCase(tAddressId), returnsNormally);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockAddressRepository.selectAddress(any),
      ).thenThrow(Exception('Failed to select address'));

      // act & assert
      expect(() async => await useCase(tAddressId), throwsA(isA<Exception>()));
      verify(mockAddressRepository.selectAddress(tAddressId));
    });
  });
}
