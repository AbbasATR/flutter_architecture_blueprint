import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/usecases/get_items_by_supplier_id.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_bloc.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_event.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_state.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ItemBloc itemBloc;
  late MockGetItemsBySupplierId mockGetItemsBySupplierId;

  setUp(() {
    mockGetItemsBySupplierId = MockGetItemsBySupplierId();
    itemBloc = ItemBloc(getItemsBySupplierId: mockGetItemsBySupplierId);
  });

  tearDown(() {
    itemBloc.close();
  });

  final tItems = [
    Item(
      id: 1,
      name: 'Test Item 1',
      shortDescription: 'Short description 1',
      description: 'Full description 1',
      imageURL: 'test1.jpg',
      price: 10.0,
      categoryId: 1,
      supplierId: 1,
      isAvailable: true,
      rating: 4.5,
      reviewCount: 10,
      updatedAt: DateTime(2024, 1, 1),
      type: ItemType.food,
      metadata: {},
      prepTimeMinutes: 30,
      status: ItemStatus.available,
    ),
    Item(
      id: 2,
      name: 'Test Item 2',
      shortDescription: 'Short description 2',
      description: 'Full description 2',
      imageURL: 'test2.jpg',
      price: 15.0,
      categoryId: 1,
      supplierId: 1,
      isAvailable: true,
      rating: 4.0,
      reviewCount: 5,
      updatedAt: DateTime(2024, 1, 2),
      type: ItemType.food,
      metadata: {},
      prepTimeMinutes: 25,
      status: ItemStatus.available,
    ),
  ];

  const tSupplierId = 1;

  test('initial state should be ItemInitial', () {
    expect(itemBloc.state, equals(const ItemInitial()));
  });

  group('LoadItems', () {
    blocTest<ItemBloc, ItemState>(
      'should emit [Loading, Loaded] when loading items succeeds',
      build: () {
        when(
          mockGetItemsBySupplierId(any),
        ).thenAnswer((_) async => Right(tItems));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const LoadItems(tSupplierId)),
      expect: () => [const ItemLoading(), ItemLoaded(tItems)],
      verify: (_) {
        verify(
          mockGetItemsBySupplierId(
            const GetItemsBySupplierIdParams(supplierId: tSupplierId),
          ),
        ).called(1);
      },
    );

    blocTest<ItemBloc, ItemState>(
      'should emit [Loading, Error] when loading items fails',
      build: () {
        when(mockGetItemsBySupplierId(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to load items')),
        );
        return itemBloc;
      },
      act: (bloc) => bloc.add(const LoadItems(tSupplierId)),
      expect: () => [
        const ItemLoading(),
        const ItemError('Failed to load items'),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'should emit [Loading, Loaded] with empty list when no items found',
      build: () {
        when(
          mockGetItemsBySupplierId(any),
        ).thenAnswer((_) async => const Right([]));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const LoadItems(tSupplierId)),
      expect: () => [const ItemLoading(), const ItemLoaded([])],
    );
  });

  group('RefreshItems', () {
    blocTest<ItemBloc, ItemState>(
      'should emit [Loaded] when refreshing items succeeds',
      build: () {
        when(
          mockGetItemsBySupplierId(any),
        ).thenAnswer((_) async => Right(tItems));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const RefreshItems(tSupplierId)),
      expect: () => [ItemLoaded(tItems)],
      verify: (_) {
        verify(
          mockGetItemsBySupplierId(
            const GetItemsBySupplierIdParams(supplierId: tSupplierId),
          ),
        ).called(1);
      },
    );

    blocTest<ItemBloc, ItemState>(
      'should emit [Error] when refreshing items fails',
      build: () {
        when(
          mockGetItemsBySupplierId(any),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const RefreshItems(tSupplierId)),
      expect: () => [const ItemError('Network error')],
    );

    blocTest<ItemBloc, ItemState>(
      'should not emit Loading state when refreshing',
      build: () {
        when(
          mockGetItemsBySupplierId(any),
        ).thenAnswer((_) async => Right(tItems));
        return itemBloc;
      },
      seed: () => const ItemLoaded([]),
      act: (bloc) => bloc.add(const RefreshItems(tSupplierId)),
      expect: () => [ItemLoaded(tItems)],
      verify: (_) {
        verify(
          mockGetItemsBySupplierId(
            const GetItemsBySupplierIdParams(supplierId: tSupplierId),
          ),
        ).called(1);
      },
    );
  });
}
