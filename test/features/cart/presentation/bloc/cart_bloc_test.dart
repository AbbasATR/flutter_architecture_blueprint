import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CartBloc cartBloc;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    cartBloc = CartBloc(repository: mockCartRepository);
  });

  tearDown(() {
    cartBloc.close();
  });

  final tItem = Item(
    id: 1,
    name: 'Test Item',
    shortDescription: 'Test Description',
    description: 'Full test description',
    imageURL: 'test.jpg',
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
  );

  final tCartItem = CartItem(
    id: '1',
    item: tItem,
    quantity: 2,
    sizePrice: 0.0,
    addedAt: DateTime(2024, 1, 1),
  );

  final tCartItems = [tCartItem];

  test('initial state should be CartInitial', () {
    expect(cartBloc.state, equals(const CartInitial()));
  });

  group('LoadCartEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loading, Loaded] when loading cart succeeds',
      build: () {
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const LoadCartEvent()),
      expect: () => [
        const CartLoading(),
        CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2),
      ],
      verify: (_) {
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Loading, Error] when loading cart fails',
      build: () {
        when(mockCartRepository.getCartItems()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to load cart')),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(const LoadCartEvent()),
      expect: () => [
        const CartLoading(),
        const CartError('Failed to load cart'),
      ],
    );
  });

  group('AddToCartEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [OperationSuccess] when adding item succeeds',
      build: () {
        when(
          mockCartRepository.addCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddToCartEvent(tCartItem)),
      expect: () => [
        CartOperationSuccess(
          message: 'Item added to cart',
          items: tCartItems,
          totalPrice: 20.0,
          totalItems: 2,
        ),
      ],
      verify: (_) {
        verify(mockCartRepository.addCartItem(tCartItem)).called(1);
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Error] when adding item fails',
      build: () {
        when(mockCartRepository.addCartItem(any)).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to add item')),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddToCartEvent(tCartItem)),
      expect: () => [const CartError('Failed to add item')],
    );
  });

  group('UpdateCartItemEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loaded] when updating item succeeds',
      build: () {
        when(
          mockCartRepository.updateCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(UpdateCartItemEvent(tCartItem)),
      expect: () => [
        CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2),
      ],
      verify: (_) {
        verify(mockCartRepository.updateCartItem(tCartItem)).called(1);
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Error] when updating item fails',
      build: () {
        when(mockCartRepository.updateCartItem(any)).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to update item')),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(UpdateCartItemEvent(tCartItem)),
      expect: () => [const CartError('Failed to update item')],
    );
  });

  group('DeleteCartItemEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loaded] with updated cart when deleting item succeeds',
      build: () {
        when(
          mockCartRepository.deleteCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => const Right([]));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const DeleteCartItemEvent('1')),
      expect: () => [const CartLoaded(items: [], totalPrice: 0, totalItems: 0)],
      verify: (_) {
        verify(mockCartRepository.deleteCartItem('1')).called(1);
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Error] when deleting item fails',
      build: () {
        when(mockCartRepository.deleteCartItem(any)).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to delete item')),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(const DeleteCartItemEvent('1')),
      expect: () => [const CartError('Failed to delete item')],
    );
  });

  group('IncrementQuantityEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loaded] when incrementing quantity succeeds',
      build: () {
        when(
          mockCartRepository.getCartItemById(any),
        ).thenAnswer((_) async => Right(tCartItem));
        when(
          mockCartRepository.updateCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const IncrementQuantityEvent('1')),
      expect: () => [
        CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2),
      ],
      verify: (_) {
        verify(mockCartRepository.getCartItemById('1')).called(1);
        verify(mockCartRepository.updateCartItem(any)).called(1);
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Error] when item not found',
      build: () {
        when(
          mockCartRepository.getCartItemById(any),
        ).thenAnswer((_) async => const Right(null));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const IncrementQuantityEvent('1')),
      expect: () => [],
    );
  });

  group('DecrementQuantityEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loaded] when decrementing quantity succeeds',
      build: () {
        final itemWithQuantity3 = tCartItem.copyWith(quantity: 3);
        when(
          mockCartRepository.getCartItemById(any),
        ).thenAnswer((_) async => Right(itemWithQuantity3));
        when(
          mockCartRepository.updateCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const DecrementQuantityEvent('1')),
      expect: () => [
        CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2),
      ],
      verify: (_) {
        verify(mockCartRepository.getCartItemById('1')).called(1);
        verify(mockCartRepository.updateCartItem(any)).called(1);
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should delete item when quantity is 1',
      build: () {
        final itemWithQuantity1 = tCartItem.copyWith(quantity: 1);
        when(
          mockCartRepository.getCartItemById(any),
        ).thenAnswer((_) async => Right(itemWithQuantity1));
        when(
          mockCartRepository.deleteCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => const Right([]));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const DecrementQuantityEvent('1')),
      expect: () => [const CartLoaded(items: [], totalPrice: 0, totalItems: 0)],
      verify: (_) {
        verify(mockCartRepository.getCartItemById('1')).called(1);
      },
    );
  });

  group('ClearCartEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loaded] with empty cart when clearing succeeds',
      build: () {
        when(
          mockCartRepository.clearCart(),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [const CartLoaded(items: [], totalPrice: 0, totalItems: 0)],
      verify: (_) {
        verify(mockCartRepository.clearCart()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Error] when clearing fails',
      build: () {
        when(mockCartRepository.clearCart()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to clear cart')),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [const CartError('Failed to clear cart')],
    );
  });

  group('ReplaceCartAndAddEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [OperationSuccess] when replacing cart succeeds',
      build: () {
        when(
          mockCartRepository.clearCart(),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.addCartItem(any),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        when(
          mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(ReplaceCartAndAddEvent(tCartItem)),
      expect: () => [
        CartOperationSuccess(
          message: 'Cart replaced with new item',
          items: tCartItems,
          totalPrice: 20.0,
          totalItems: 2,
        ),
      ],
      verify: (_) {
        verify(mockCartRepository.clearCart()).called(1);
        verify(mockCartRepository.addCartItem(tCartItem)).called(1);
        verify(mockCartRepository.getCartItems()).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit [Error] when clearing cart fails',
      build: () {
        when(mockCartRepository.clearCart()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to clear cart')),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(ReplaceCartAndAddEvent(tCartItem)),
      expect: () => [const CartError('Failed to clear cart')],
    );
  });

  group('getCartSupplierId', () {
    test('should return null when cart is empty', () {
      expect(cartBloc.getCartSupplierId(), isNull);
    });

    test('should return supplier ID from CartLoaded state', () {
      cartBloc.emit(
        CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2),
      );
      expect(cartBloc.getCartSupplierId(), equals(1));
    });

    test('should return supplier ID from CartOperationSuccess state', () {
      cartBloc.emit(
        CartOperationSuccess(
          message: 'Success',
          items: tCartItems,
          totalPrice: 20.0,
          totalItems: 2,
        ),
      );
      expect(cartBloc.getCartSupplierId(), equals(1));
    });
  });
}
