import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_items.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchItems usecase;
  late MockSearchRepository mockSearchRepository;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    usecase = SearchItems(mockSearchRepository);
  });

  const tQuery = 'pizza';
  final tSearchItems = [
    const SearchItem(
      id: '1',
      name: 'Margherita Pizza',
      description: 'Classic tomato and mozzarella',
      imageUrl: 'margherita.jpg',
      price: 12.99,
      supplierId: '1',
      supplierName: 'Pizza Palace',
      category: 'Food',
      rating: 4.7,
    ),
    const SearchItem(
      id: '2',
      name: 'Pepperoni Pizza',
      description: 'Loaded with pepperoni',
      imageUrl: 'pepperoni.jpg',
      price: 14.99,
      supplierId: '1',
      supplierName: 'Pizza Palace',
      category: 'Food',
      rating: 4.8,
    ),
  ];

  test('should return list of search items from repository', () async {
    // arrange
    when(
      mockSearchRepository.searchItems(any),
    ).thenAnswer((_) async => Right(tSearchItems));

    // act
    final result = await usecase(const SearchItemsParams(query: tQuery));

    // assert
    expect(result, Right(tSearchItems));
    verify(mockSearchRepository.searchItems(tQuery));
    verifyNoMoreInteractions(mockSearchRepository);
  });

  test('should return empty list when no items found', () async {
    // arrange
    when(
      mockSearchRepository.searchItems(any),
    ).thenAnswer((_) async => const Right<Failure, List<SearchItem>>([]));

    // act
    final result = await usecase(const SearchItemsParams(query: tQuery));

    // assert
    expect(result, const Right<Failure, List<SearchItem>>([]));
    verify(mockSearchRepository.searchItems(tQuery));
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    const tFailure = ServerFailure('Failed to search items');
    when(
      mockSearchRepository.searchItems(any),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(const SearchItemsParams(query: tQuery));

    // assert
    expect(result, const Left(tFailure));
    verify(mockSearchRepository.searchItems(tQuery));
  });

  test('should return ServerFailure when network error occurs', () async {
    // arrange
    const tFailure = ServerFailure('Network error occurred');
    when(
      mockSearchRepository.searchItems(any),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(const SearchItemsParams(query: tQuery));

    // assert
    expect(result, const Left(tFailure));
    verify(mockSearchRepository.searchItems(tQuery));
  });

  test('should pass correct query to repository', () async {
    // arrange
    const tCustomQuery = 'burger';
    when(
      mockSearchRepository.searchItems(any),
    ).thenAnswer((_) async => const Right<Failure, List<SearchItem>>([]));

    // act
    await usecase(const SearchItemsParams(query: tCustomQuery));

    // assert
    verify(mockSearchRepository.searchItems(tCustomQuery));
  });

  test('should handle empty query string', () async {
    // arrange
    when(
      mockSearchRepository.searchItems(any),
    ).thenAnswer((_) async => const Right<Failure, List<SearchItem>>([]));

    // act
    final result = await usecase(const SearchItemsParams(query: ''));

    // assert
    expect(result, const Right<Failure, List<SearchItem>>([]));
    verify(mockSearchRepository.searchItems(''));
  });

  group('SearchItemsParams', () {
    test('should have correct props for equality', () {
      const params1 = SearchItemsParams(query: 'pizza');
      const params2 = SearchItemsParams(query: 'pizza');
      const params3 = SearchItemsParams(query: 'burger');

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
