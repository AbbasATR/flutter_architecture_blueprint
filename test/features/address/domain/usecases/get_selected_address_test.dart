import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_selected_address.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetSelectedAddress useCase;
  late MockAddressRepository mockAddressRepository;

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    useCase = GetSelectedAddress(mockAddressRepository);
  });

  const tAddress = Address(
    id: '1',
    name: 'Home',
    details: '123 Main Street, Dubai',
    icon: 'home_icon',
    isCurrentLocation: false,
  );

  group('GetSelectedAddress', () {
    test('should call repository.getSelectedAddress', () async {
      // arrange
      when(
        mockAddressRepository.getSelectedAddress(),
      ).thenAnswer((_) async => tAddress);

      // act
      await useCase();

      // assert
      verify(mockAddressRepository.getSelectedAddress());
      verifyNoMoreInteractions(mockAddressRepository);
    });

    test('should return selected address when available', () async {
      // arrange
      when(
        mockAddressRepository.getSelectedAddress(),
      ).thenAnswer((_) async => tAddress);

      // act
      final result = await useCase();

      // assert
      expect(result, tAddress);
      expect(result?.id, '1');
      expect(result?.name, 'Home');
    });

    test('should return null when no address is selected', () async {
      // arrange
      when(
        mockAddressRepository.getSelectedAddress(),
      ).thenAnswer((_) async => null);

      // act
      final result = await useCase();

      // assert
      expect(result, isNull);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockAddressRepository.getSelectedAddress(),
      ).thenThrow(Exception('Failed to fetch selected address'));

      // act & assert
      expect(() async => await useCase(), throwsA(isA<Exception>()));
      verify(mockAddressRepository.getSelectedAddress());
    });
  });
}
