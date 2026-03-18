import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/add_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/clear_cart.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/delete_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_item_by_id.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_items.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/update_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';

class MockGetCartItems extends Mock implements GetCartItems {}
class MockAddCartItem extends Mock implements AddCartItem {}
class MockUpdateCartItem extends Mock implements UpdateCartItem {}
class MockDeleteCartItem extends Mock implements DeleteCartItem {}
class MockClearCart extends Mock implements ClearCart {}
class MockGetCartItemById extends Mock implements GetCartItemById {}

void main() {
  late CartBloc cartBloc;
  late MockGetCartItems mockGetCartItems;
  late MockAddCartItem mockAddCartItem;
  late MockUpdateCartItem mockUpdateCartItem;
  late MockDeleteCartItem mockDeleteCartItem;
  late MockClearCart mockClearCart;
  late MockGetCartItemById mockGetCartItemById;

  setUp(() {
    mockGetCartItems = MockGetCartItems();
    mockAddCartItem = MockAddCartItem();
    mockUpdateCartItem = MockUpdateCartItem();
    mockDeleteCartItem = MockDeleteCartItem();
    mockClearCart = MockClearCart();
    mockGetCartItemById = MockGetCartItemById();
    cartBloc = CartBloc(
      getCartItems: mockGetCartItems,
      addCartItem: mockAddCartItem,
      updateCartItem: mockUpdateCartItem,
      deleteCartItem: mockDeleteCartItem,
      clearCart: mockClearCart,
      getCartItemById: mockGetCartItemById,
    );
  });

  tearDown(() => cartBloc.close());

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
    metadata: const {},
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

  late List<CartItem> tCartItems;

  setUp(() {
    tCartItems = [tCartItem];
  });

  test('initial state should be CartInitial', () {
    expect(cartBloc.state, equals(const CartInitial()));
  });

  group('LoadCartEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit [Loading, Loaded] when loading cart succeeds',
      build: () {
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const LoadCartEvent()),
      expect: () => [const CartLoading(), CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2)],
      verify: (_) => verify(mockGetCartItems(const NoParams())).called(1),
    );

    blocTest<CartBloc, CartState>(
      'should emit [Loading, Error] when loading cart fails',
      build: () {
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => const Left(CacheFailure('Failed to load cart')));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const LoadCartEvent()),
      expect: () => [const CartLoading(), const CartError('Failed to load cart')],
    );
  });

  group('mutation events', () {
    blocTest<CartBloc, CartState>(
      'should emit operation success when adding item succeeds',
      build: () {
        when(mockAddCartItem(AddCartItemParams(tCartItem))).thenAnswer((_) async => const Right(unit));
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddToCartEvent(tCartItem)),
      expect: () => [CartOperationSuccess(message: 'Item added to cart', items: tCartItems, totalPrice: 20.0, totalItems: 2)],
      verify: (_) {
        verify(mockAddCartItem(AddCartItemParams(tCartItem))).called(1);
        verify(mockGetCartItems(const NoParams())).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'should emit loaded when updating item succeeds',
      build: () {
        when(mockUpdateCartItem(UpdateCartItemParams(tCartItem))).thenAnswer((_) async => const Right(unit));
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(UpdateCartItemEvent(tCartItem)),
      expect: () => [CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2)],
    );

    blocTest<CartBloc, CartState>(
      'should emit loaded with empty cart when deleting item succeeds',
      build: () {
        when(mockDeleteCartItem(const DeleteCartItemParams('1'))).thenAnswer((_) async => const Right(unit));
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => const Right(<CartItem>[]));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const DeleteCartItemEvent('1')),
      expect: () => [const CartLoaded(items: [], totalPrice: 0, totalItems: 0)],
    );

    blocTest<CartBloc, CartState>(
      'should emit loaded with empty cart when clearing succeeds',
      build: () {
        when(mockClearCart(const NoParams())).thenAnswer((_) async => const Right(unit));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [const CartLoaded(items: [], totalPrice: 0, totalItems: 0)],
    );
  });

  group('quantity events', () {
    blocTest<CartBloc, CartState>(
      'should increment quantity and reload cart',
      build: () {
        when(mockGetCartItemById(const GetCartItemByIdParams('1'))).thenAnswer((_) async => Right(tCartItem));
        when(mockUpdateCartItem(any)).thenAnswer((_) async => const Right(unit));
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const IncrementQuantityEvent('1')),
      expect: () => [CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2)],
    );

    blocTest<CartBloc, CartState>(
      'should decrement quantity and reload cart',
      build: () {
        when(mockGetCartItemById(const GetCartItemByIdParams('1'))).thenAnswer((_) async => Right(tCartItem.copyWith(quantity: 3)));
        when(mockUpdateCartItem(any)).thenAnswer((_) async => const Right(unit));
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const DecrementQuantityEvent('1')),
      expect: () => [CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2)],
    );
  });

  group('ReplaceCartAndAddEvent', () {
    blocTest<CartBloc, CartState>(
      'should emit operation success when replacing cart succeeds',
      build: () {
        when(mockClearCart(const NoParams())).thenAnswer((_) async => const Right(unit));
        when(mockAddCartItem(AddCartItemParams(tCartItem))).thenAnswer((_) async => const Right(unit));
        when(mockGetCartItems(const NoParams())).thenAnswer((_) async => Right(tCartItems));
        return cartBloc;
      },
      act: (bloc) => bloc.add(ReplaceCartAndAddEvent(tCartItem)),
      expect: () => [CartOperationSuccess(message: 'Cart replaced with new item', items: tCartItems, totalPrice: 20.0, totalItems: 2)],
    );
  });

  group('getCartSupplierId', () {
    test('should return null when cart is empty', () {
      expect(cartBloc.getCartSupplierId(), isNull);
    });

    test('should return supplier ID from CartLoaded state', () {
      cartBloc.emit(CartLoaded(items: tCartItems, totalPrice: 20.0, totalItems: 2));
      expect(cartBloc.getCartSupplierId(), equals(1));
    });

    test('should return supplier ID from CartOperationSuccess state', () {
      cartBloc.emit(CartOperationSuccess(message: 'Success', items: tCartItems, totalPrice: 20.0, totalItems: 2));
      expect(cartBloc.getCartSupplierId(), equals(1));
    });
  });
}
