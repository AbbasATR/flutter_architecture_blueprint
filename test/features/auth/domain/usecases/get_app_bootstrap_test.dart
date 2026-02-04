import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/get_app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_brand.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_category.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetAppBootstrap useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetAppBootstrap(mockAuthRepository);
  });

  const tAccessToken = 'test_access_token_123';
  const tParams = GetAppBootstrapParams(accessToken: tAccessToken);

  const tHomeCategory = HomeCategory(
    id: '1',
    label: 'Pizza',
    iconAsset: 'pizza_icon.png',
  );

  const tHomeBrand = HomeBrand(
    id: '1',
    name: 'Dominos',
    tagline: 'You Got 30 Minutes',
    imageAsset: 'dominos_logo.png',
  );

  const tHomeBootstrap = HomeBootstrap(
    categories: [tHomeCategory],
    brands: [tHomeBrand],
    savedItems: [],
    newListings: [],
  );

  group('GetAppBootstrap', () {
    test(
      'should call repository.getAppBootstrap with correct access token',
      () async {
        // arrange
        when(
          mockAuthRepository.getAppBootstrap(any),
        ).thenAnswer((_) async => const Right(tHomeBootstrap));

        // act
        await useCase(tParams);

        // assert
        verify(mockAuthRepository.getAppBootstrap(tAccessToken));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should return HomeBootstrap when fetch is successful', () async {
      // arrange
      when(
        mockAuthRepository.getAppBootstrap(any),
      ).thenAnswer((_) async => const Right(tHomeBootstrap));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tHomeBootstrap));
      result.fold((failure) => fail('Should not return failure'), (bootstrap) {
        expect(bootstrap.categories.length, 1);
        expect(bootstrap.brands.length, 1);
        expect(bootstrap.categories.first.label, 'Pizza');
      });
    });

    test(
      'should return ServerFailure when repository returns ServerFailure',
      () async {
        // arrange
        const tServerFailure = ServerFailure('Failed to fetch bootstrap');
        when(
          mockAuthRepository.getAppBootstrap(any),
        ).thenAnswer((_) async => const Left(tServerFailure));

        // act
        final result = await useCase(tParams);

        // assert
        expect(result, const Left(tServerFailure));
        verify(mockAuthRepository.getAppBootstrap(tAccessToken));
      },
    );

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      final tNetworkFailure = NetworkFailure();
      when(
        mockAuthRepository.getAppBootstrap(any),
      ).thenAnswer((_) async => Left(tNetworkFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Left(tNetworkFailure));
      verify(mockAuthRepository.getAppBootstrap(tAccessToken));
    });

    test('should return UnauthorizedFailure for invalid token', () async {
      // arrange
      const tUnauthorizedFailure = ServerFailure('Invalid or expired token');
      when(
        mockAuthRepository.getAppBootstrap(any),
      ).thenAnswer((_) async => const Left(tUnauthorizedFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tUnauthorizedFailure));
    });
  });

  group('GetAppBootstrapParams', () {
    test('should support value equality', () {
      // arrange
      const params1 = GetAppBootstrapParams(accessToken: tAccessToken);
      const params2 = GetAppBootstrapParams(accessToken: tAccessToken);

      // assert
      expect(params1, params2);
    });

    test('props should contain accessToken', () {
      // arrange
      const params = GetAppBootstrapParams(accessToken: tAccessToken);

      // assert
      expect(params.props, [tAccessToken]);
    });
  });
}
