import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_bootstrap_model.dart';
import 'package:flutter_architecture_blueprint/features/home/data/repositories/home_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = HomeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tHomeBootstrap = HomeBootstrapModel(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );

  group('fetchHomeBootstrap', () {
    test(
      'should return HomeBootstrap when network is connected and call succeeds',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.fetchHomeBootstrap(),
        ).thenAnswer((_) async => const Right(tHomeBootstrap));

        // Act
        final result = await repository.fetchHomeBootstrap();

        // Assert
        expect(result, equals(const Right(tHomeBootstrap)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.fetchHomeBootstrap());
      },
    );

    test(
      'should throw Exception with network message when no internet',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final call = repository.fetchHomeBootstrap;

        // Assert
        expect(await call(), equals(Left(NetworkFailure())));
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockRemoteDataSource.fetchHomeBootstrap());
      },
    );

    test('should return failure when remote data source fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.fetchHomeBootstrap(),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));

      final result = await repository.fetchHomeBootstrap();

      expect(result, equals(Left(ServerFailure('Server error'))));
    });

    test('should return cache failure when cache failure occurs', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.fetchHomeBootstrap(),
      ).thenAnswer((_) async => Left(CacheFailure('Cache error')));

      final result = await repository.fetchHomeBootstrap();

      expect(result, equals(Left(CacheFailure('Cache error'))));
    });
  });
}
