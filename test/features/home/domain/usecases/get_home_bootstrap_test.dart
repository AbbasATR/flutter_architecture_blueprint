import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_brand.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_category.dart';
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
      ).thenAnswer((_) async => tHomeBootstrap);

      // act
      await useCase();

      // assert
      verify(mockHomeRepository.fetchHomeBootstrap());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test('should return HomeBootstrap when fetch is successful', () async {
      // arrange
      when(
        mockHomeRepository.fetchHomeBootstrap(),
      ).thenAnswer((_) async => tHomeBootstrap);

      // act
      final result = await useCase();

      // assert
      expect(result, tHomeBootstrap);
      expect(result.categories, [tHomeCategory]);
      expect(result.brands, [tHomeBrand]);
      expect(result.savedItems, isEmpty);
      expect(result.newListings, isEmpty);
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
      ).thenAnswer((_) async => tEmptyBootstrap);

      // act
      final result = await useCase();

      // assert
      expect(result, tEmptyBootstrap);
      expect(result.categories, isEmpty);
      expect(result.brands, isEmpty);
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        mockHomeRepository.fetchHomeBootstrap(),
      ).thenThrow(Exception('Network error'));

      // act & assert
      expect(() async => await useCase(), throwsA(isA<Exception>()));
      verify(mockHomeRepository.fetchHomeBootstrap());
    });
  });
}
