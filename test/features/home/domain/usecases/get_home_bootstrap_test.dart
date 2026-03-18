import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_brand.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_category.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/usecases/get_home_bootstrap.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetHomeBootstrapUseCase useCase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetHomeBootstrapUseCase(mockHomeRepository);
  });

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

  group('GetHomeBootstrapUseCase', () {
    test('should call repository.fetchHomeBootstrap', () async {
      // arrange
      when(
        mockHomeRepository.fetchHomeBootstrap(),
).thenAnswer((_) async => const Right(tHomeBootstrap));

      // act
      await useCase(const NoParams());

      // assert
      verify(mockHomeRepository.fetchHomeBootstrap());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test('should return HomeBootstrap when fetch is successful', () async {
      // arrange
      when(
        mockHomeRepository.fetchHomeBootstrap(),
).thenAnswer((_) async => const Right(tHomeBootstrap));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result, const Right(tHomeBootstrap));
      result.fold((failure) => fail('Expected success'), (bootstrap) {
        expect(bootstrap.categories, [tHomeCategory]);
        expect(bootstrap.brands, [tHomeBrand]);
        expect(bootstrap.savedItems, isEmpty);
        expect(bootstrap.newListings, isEmpty);
      });
    });

    test('should return empty lists when no data is available', () async {
      // arrange
      const tEmptyBootstrap = HomeBootstrap(
        categories: [],
        brands: [],
        savedItems: [],
        newListings: [],
      );
      when(
        mockHomeRepository.fetchHomeBootstrap(),
).thenAnswer((_) async => const Right(tEmptyBootstrap));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result, const Right(tEmptyBootstrap));
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockHomeRepository.fetchHomeBootstrap(),
).thenAnswer((_) async => Left(NetworkFailure()));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result, Left(NetworkFailure()));
      verify(mockHomeRepository.fetchHomeBootstrap());
    });
  });
}
