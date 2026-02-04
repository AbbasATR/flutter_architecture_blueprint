import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_addresses.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetAddresses useCase;
  late MockAddressRepository mockAddressRepository;

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    useCase = GetAddresses(mockAddressRepository);
  });

  const tAddress = Address(
    id: '1',
    name: 'Home',
    details: '123 Main Street, Dubai',
    icon: 'home_icon',
    isCurrentLocation: false,
  );

  final tAddressList = [tAddress];

  group('GetAddresses', () {
    test('should call repository.getAddresses', () async {
      // arrange
      when(
        mockAddressRepository.getAddresses(),
      ).thenAnswer((_) async => tAddressList);

      // act
      await useCase();

      // assert
      verify(mockAddressRepository.getAddresses());
      verifyNoMoreInteractions(mockAddressRepository);
    });

    test('should return list of addresses when fetch is successful', () async {
      // arrange
      when(
        mockAddressRepository.getAddresses(),
      ).thenAnswer((_) async => tAddressList);

      // act
      final result = await useCase();

      // assert
      expect(result, tAddressList);
      expect(result.length, 1);
      expect(result.first.id, '1');
      expect(result.first.name, 'Home');
      expect(result.first.details, '123 Main Street, Dubai');
    });

    test('should return empty list when no addresses are saved', () async {
      // arrange
      when(mockAddressRepository.getAddresses()).thenAnswer((_) async => []);

      // act
      final result = await useCase();

      // assert
      expect(result, isEmpty);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockAddressRepository.getAddresses(),
      ).thenThrow(Exception('Failed to fetch addresses'));

      // act & assert
      expect(() async => await useCase(), throwsA(isA<Exception>()));
      verify(mockAddressRepository.getAddresses());
    });
  });
}
