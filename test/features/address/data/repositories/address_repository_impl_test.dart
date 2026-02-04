import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/address/data/models/address_model.dart';
import 'package:flutter_architecture_blueprint/features/address/data/repositories/address_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AddressRepositoryImpl repository;
  late MockAddressLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockAddressLocalDataSource();
    repository = AddressRepositoryImpl(mockLocalDataSource);
  });

  const tAddress1 = AddressModel(
    id: '1',
    name: 'Home',
    details: '123 Main St, Dubai, UAE',
    icon: 'home',
    isCurrentLocation: false,
  );

  const tAddress2 = AddressModel(
    id: '2',
    name: 'Work',
    details: '456 Side St, Abu Dhabi, UAE',
    icon: 'work',
    isCurrentLocation: false,
  );

  final tAddresses = [tAddress1, tAddress2];

  group('getAddresses', () {
    test('should return list of addresses from local data source', () async {
      // Arrange
      when(
        mockLocalDataSource.getAddresses(),
      ).thenAnswer((_) async => tAddresses);

      // Act
      final result = await repository.getAddresses();

      // Assert
      expect(result, equals(tAddresses));
      verify(mockLocalDataSource.getAddresses());
    });

    test('should return empty list when no addresses', () async {
      // Arrange
      when(mockLocalDataSource.getAddresses()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getAddresses();

      // Assert
      expect(result, isEmpty);
      verify(mockLocalDataSource.getAddresses());
    });
  });

  group('getSelectedAddress', () {
    test('should return selected address from local data source', () async {
      // Arrange
      when(
        mockLocalDataSource.getSelectedAddress(),
      ).thenAnswer((_) async => tAddress1);

      // Act
      final result = await repository.getSelectedAddress();

      // Assert
      expect(result, equals(tAddress1));
      verify(mockLocalDataSource.getSelectedAddress());
    });

    test('should return null when no address selected', () async {
      // Arrange
      when(
        mockLocalDataSource.getSelectedAddress(),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getSelectedAddress();

      // Assert
      expect(result, isNull);
      verify(mockLocalDataSource.getSelectedAddress());
    });
  });

  group('selectAddress', () {
    test('should call local data source selectAddress', () async {
      // Arrange
      const tAddressId = '1';
      when(
        mockLocalDataSource.selectAddress(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      await repository.selectAddress(tAddressId);

      // Assert
      verify(mockLocalDataSource.selectAddress(tAddressId));
    });
  });
}
