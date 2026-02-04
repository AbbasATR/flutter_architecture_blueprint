import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_items.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_suppliers.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_state.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchBloc searchBloc;
  late MockSearchItems mockSearchItems;
  late MockSearchSuppliers mockSearchSuppliers;

  setUp(() {
    mockSearchItems = MockSearchItems();
    mockSearchSuppliers = MockSearchSuppliers();
    searchBloc = SearchBloc(
      searchItems: mockSearchItems,
      searchSuppliers: mockSearchSuppliers,
    );
  });

  tearDown(() {
    searchBloc.close();
  });

  const tQuery = 'pizza';
  const tEmptyQuery = '';
  const tWhitespaceQuery = '   ';

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

  test('initial state should be SearchInitial', () {
    expect(searchBloc.state, equals(const SearchInitial()));
  });

  group('SearchQueryChanged', () {
    blocTest<SearchBloc, SearchState>(
      'should emit [Initial] when query is empty',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const SearchQueryChanged(tEmptyQuery)),
      expect: () => [const SearchInitial()],
      verify: (_) {
        verifyNever(mockSearchSuppliers(any));
        verifyNever(mockSearchItems(any));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Initial] when query is only whitespace',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const SearchQueryChanged(tWhitespaceQuery)),
      expect: () => [const SearchInitial()],
      verify: (_) {
        verifyNever(mockSearchSuppliers(any));
        verifyNever(mockSearchItems(any));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, Loaded] when search succeeds',
      build: () {
        when(
          mockSearchSuppliers(any),
        ).thenAnswer((_) async => Right(tSearchSuppliers));
        when(mockSearchItems(any)).thenAnswer((_) async => Right(tSearchItems));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
      expect: () => [
        const SearchLoading(),
        SearchLoaded(
          suppliers: tSearchSuppliers,
          items: tSearchItems,
          query: tQuery,
          currentTabIndex: 0,
        ),
      ],
      verify: (_) {
        verify(
          mockSearchSuppliers(const SearchSuppliersParams(query: tQuery)),
        ).called(1);
        verify(
          mockSearchItems(const SearchItemsParams(query: tQuery)),
        ).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, Error] when supplier search fails',
      build: () {
        when(mockSearchSuppliers(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to search suppliers')),
        );
        when(mockSearchItems(any)).thenAnswer((_) async => Right(tSearchItems));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
      expect: () => [
        const SearchLoading(),
        const SearchError('Failed to search suppliers'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, Error] when item search fails',
      build: () {
        when(
          mockSearchSuppliers(any),
        ).thenAnswer((_) async => Right(tSearchSuppliers));
        when(mockSearchItems(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to search items')),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
      expect: () => [
        const SearchLoading(),
        const SearchError('Failed to search items'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Loading, Loaded] with empty results when nothing found',
      build: () {
        when(mockSearchSuppliers(any)).thenAnswer((_) async => const Right([]));
        when(mockSearchItems(any)).thenAnswer((_) async => const Right([]));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
      expect: () => [
        const SearchLoading(),
        const SearchLoaded(
          suppliers: [],
          items: [],
          query: tQuery,
          currentTabIndex: 0,
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'should trim query before searching',
      build: () {
        when(
          mockSearchSuppliers(any),
        ).thenAnswer((_) async => Right(tSearchSuppliers));
        when(mockSearchItems(any)).thenAnswer((_) async => Right(tSearchItems));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('  $tQuery  ')),
      expect: () => [
        const SearchLoading(),
        SearchLoaded(
          suppliers: tSearchSuppliers,
          items: tSearchItems,
          query: tQuery,
          currentTabIndex: 0,
        ),
      ],
      verify: (_) {
        verify(
          mockSearchSuppliers(const SearchSuppliersParams(query: tQuery)),
        ).called(1);
        verify(
          mockSearchItems(const SearchItemsParams(query: tQuery)),
        ).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should handle multiple searches sequentially',
      build: () {
        when(
          mockSearchSuppliers(any),
        ).thenAnswer((_) async => Right(tSearchSuppliers));
        when(mockSearchItems(any)).thenAnswer((_) async => Right(tSearchItems));
        return searchBloc;
      },
      act: (bloc) async {
        bloc.add(const SearchQueryChanged('pizza'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const SearchQueryChanged('burger'));
      },
      skip: 2, // Skip first search results
      expect: () => [
        const SearchLoading(),
        SearchLoaded(
          suppliers: tSearchSuppliers,
          items: tSearchItems,
          query: 'burger',
          currentTabIndex: 0,
        ),
      ],
    );
  });

  group('SearchCleared', () {
    blocTest<SearchBloc, SearchState>(
      'should emit [Initial] when search is cleared',
      build: () => searchBloc,
      seed: () => SearchLoaded(
        suppliers: tSearchSuppliers,
        items: tSearchItems,
        query: tQuery,
        currentTabIndex: 0,
      ),
      act: (bloc) => bloc.add(const SearchCleared()),
      expect: () => [const SearchInitial()],
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Initial] when clearing from initial state',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const SearchCleared()),
      expect: () => [const SearchInitial()],
    );

    blocTest<SearchBloc, SearchState>(
      'should emit [Initial] when clearing from error state',
      build: () => searchBloc,
      seed: () => const SearchError('Some error'),
      act: (bloc) => bloc.add(const SearchCleared()),
      expect: () => [const SearchInitial()],
    );
  });

  group('SearchTabChanged', () {
    blocTest<SearchBloc, SearchState>(
      'should update tab index when in Loaded state',
      build: () => searchBloc,
      seed: () => SearchLoaded(
        suppliers: tSearchSuppliers,
        items: tSearchItems,
        query: tQuery,
        currentTabIndex: 0,
      ),
      act: (bloc) => bloc.add(const SearchTabChanged(1)),
      expect: () => [
        SearchLoaded(
          suppliers: tSearchSuppliers,
          items: tSearchItems,
          query: tQuery,
          currentTabIndex: 1,
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'should not emit when not in Loaded state',
      build: () => searchBloc,
      seed: () => const SearchInitial(),
      act: (bloc) => bloc.add(const SearchTabChanged(1)),
      expect: () => [],
    );

    blocTest<SearchBloc, SearchState>(
      'should maintain search results when changing tabs',
      build: () => searchBloc,
      seed: () => SearchLoaded(
        suppliers: tSearchSuppliers,
        items: tSearchItems,
        query: tQuery,
        currentTabIndex: 0,
      ),
      act: (bloc) {
        bloc.add(const SearchTabChanged(1));
        bloc.add(const SearchTabChanged(0));
      },
      expect: () => [
        SearchLoaded(
          suppliers: tSearchSuppliers,
          items: tSearchItems,
          query: tQuery,
          currentTabIndex: 1,
        ),
        SearchLoaded(
          suppliers: tSearchSuppliers,
          items: tSearchItems,
          query: tQuery,
          currentTabIndex: 0,
        ),
      ],
    );
  });
}
