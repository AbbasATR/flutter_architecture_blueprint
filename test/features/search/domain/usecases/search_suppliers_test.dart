import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_suppliers.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchSuppliers usecase;
  late MockSearchRepository mockSearchRepository;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    usecase = SearchSuppliers(mockSearchRepository);
  });

  const tQuery = 'pizza';
  final tSearchSuppliers = [
    const SearchSupplier(
      id: '1',
      name: 'Pizza Palace',
      description: 'Best pizza in town',
      imageUrl: 'pizza-palace.jpg',
      category: 'Restaurant',
      rating: 4.5,
      reviewCount: 100,
      deliveryTime: '30-40 min',
      deliveryFee: 5.0,
    ),
    const SearchSupplier(
      id: '2',
      name: 'Mega Pizza',
      description: 'Large pizzas at great prices',
      imageUrl: 'mega-pizza.jpg',
      category: 'Restaurant',
      rating: 4.2,
      reviewCount: 75,
      deliveryTime: '25-35 min',
      deliveryFee: 3.0,
    ),
  ];

  test('should return list of search suppliers from repository', () async {
    // arrange
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => Right(tSearchSuppliers));

    // act
    final result = await usecase(const SearchSuppliersParams(query: tQuery));

    // assert
    expect(result, Right(tSearchSuppliers));
    verify(mockSearchRepository.searchSuppliers(tQuery));
    verifyNoMoreInteractions(mockSearchRepository);
  });

  test('should return empty list when no suppliers found', () async {
    // arrange
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => const Right<Failure, List<SearchSupplier>>([]));

    // act
    final result = await usecase(const SearchSuppliersParams(query: tQuery));

    // assert
    expect(result, const Right<Failure, List<SearchSupplier>>([]));
    verify(mockSearchRepository.searchSuppliers(tQuery));
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    const tFailure = ServerFailure('Failed to search suppliers');
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(const SearchSuppliersParams(query: tQuery));

    // assert
    expect(result, const Left(tFailure));
    verify(mockSearchRepository.searchSuppliers(tQuery));
  });

  test('should return ServerFailure when network error occurs', () async {
    // arrange
    const tFailure = ServerFailure('Network connection failed');
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(const SearchSuppliersParams(query: tQuery));

    // assert
    expect(result, const Left(tFailure));
    verify(mockSearchRepository.searchSuppliers(tQuery));
  });

  test('should pass correct query to repository', () async {
    // arrange
    const tCustomQuery = 'restaurant';
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => const Right<Failure, List<SearchSupplier>>([]));

    // act
    await usecase(const SearchSuppliersParams(query: tCustomQuery));

    // assert
    verify(mockSearchRepository.searchSuppliers(tCustomQuery));
  });

  test('should handle empty query string', () async {
    // arrange
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => const Right<Failure, List<SearchSupplier>>([]));

    // act
    final result = await usecase(const SearchSuppliersParams(query: ''));

    // assert
    expect(result, const Right<Failure, List<SearchSupplier>>([]));
    verify(mockSearchRepository.searchSuppliers(''));
  });

  test('should handle special characters in query', () async {
    // arrange
    const tSpecialQuery = 'café & restaurant';
    when(
      mockSearchRepository.searchSuppliers(any),
    ).thenAnswer((_) async => Right(tSearchSuppliers));

    // act
    final result = await usecase(
      const SearchSuppliersParams(query: tSpecialQuery),
    );

    // assert
    expect(result, Right(tSearchSuppliers));
    verify(mockSearchRepository.searchSuppliers(tSpecialQuery));
  });

  group('SearchSuppliersParams', () {
    test('should have correct props for equality', () {
      const params1 = SearchSuppliersParams(query: 'pizza');
      const params2 = SearchSuppliersParams(query: 'pizza');
      const params3 = SearchSuppliersParams(query: 'burger');

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('should return correct props list', () {
      const params = SearchSuppliersParams(query: 'test');
      expect(params.props, ['test']);
    });
  });
}
