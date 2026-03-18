import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/add_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/clear_cart.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/delete_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_item_by_id.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_items.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/update_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final AddCartItem addCartItem;
  final UpdateCartItem updateCartItem;
  final DeleteCartItem deleteCartItem;
  final ClearCart clearCart;
  final GetCartItemById getCartItemById;

  CartBloc({
    required this.getCartItems,
    required this.addCartItem,
    required this.updateCartItem,
    required this.deleteCartItem,
    required this.clearCart,
    required this.getCartItemById,
  }) : super(const CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<DeleteCartItemEvent>(_onDeleteCartItem);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<ReplaceCartAndAddEvent>(_onReplaceCartAndAdd);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    final result = await getCartItems(const NoParams());
    result.fold((failure) => emit(CartError(failure.message)), _emitLoadedState);
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final result = await addCartItem(AddCartItemParams(event.item));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async => _reloadAsOperationSuccess(emit, 'Item added to cart'),
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItemEvent event, Emitter<CartState> emit) async {
    final result = await updateCartItem(UpdateCartItemParams(event.item));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async => _reloadCart(emit),
    );
  }

  Future<void> _onDeleteCartItem(DeleteCartItemEvent event, Emitter<CartState> emit) async {
    final result = await deleteCartItem(DeleteCartItemParams(event.id));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async => _reloadCart(emit),
    );
  }

  Future<void> _onIncrementQuantity(IncrementQuantityEvent event, Emitter<CartState> emit) async {
    final itemResult = await getCartItemById(GetCartItemByIdParams(event.id));
    await itemResult.fold((failure) async => emit(CartError(failure.message)), (item) async {
      if (item != null) {
        final result = await updateCartItem(UpdateCartItemParams(item.copyWith(quantity: item.quantity + 1)));
        await result.fold(
          (failure) async => emit(CartError(failure.message)),
          (_) async => _reloadCart(emit),
        );
      }
    });
  }

  Future<void> _onDecrementQuantity(DecrementQuantityEvent event, Emitter<CartState> emit) async {
    final itemResult = await getCartItemById(GetCartItemByIdParams(event.id));
    await itemResult.fold((failure) async => emit(CartError(failure.message)), (item) async {
      if (item == null) return;
      if (item.quantity <= 1) {
        add(DeleteCartItemEvent(event.id));
        return;
      }
      final result = await updateCartItem(UpdateCartItemParams(item.copyWith(quantity: item.quantity - 1)));
      await result.fold(
        (failure) async => emit(CartError(failure.message)),
        (_) async => _reloadCart(emit),
      );
    });
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    final result = await clearCart(const NoParams());
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded(items: [], totalPrice: 0, totalItems: 0)),
    );
  }

  Future<void> _onReplaceCartAndAdd(ReplaceCartAndAddEvent event, Emitter<CartState> emit) async {
    final clearResult = await clearCart(const NoParams());
    await clearResult.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async {
        final addResult = await addCartItem(AddCartItemParams(event.item));
        await addResult.fold(
          (failure) async => emit(CartError(failure.message)),
          (_) async => _reloadAsOperationSuccess(emit, 'Cart replaced with new item'),
        );
      },
    );
  }

  Future<void> _reloadCart(Emitter<CartState> emit) async {
    final cartResult = await getCartItems(const NoParams());
    cartResult.fold((failure) => emit(CartError(failure.message)), _emitLoadedState);
  }

  Future<void> _reloadAsOperationSuccess(Emitter<CartState> emit, String message) async {
    final cartResult = await getCartItems(const NoParams());
    cartResult.fold((failure) => emit(CartError(failure.message)), (items) {
      emit(CartOperationSuccess(
        message: message,
        items: items,
        totalPrice: _calculateTotalPrice(items),
        totalItems: _calculateTotalItems(items),
      ));
    });
  }

  void _emitLoadedState(List items) {
    emit(CartLoaded(
      items: items,
      totalPrice: _calculateTotalPrice(items),
      totalItems: _calculateTotalItems(items),
    ));
  }

  double _calculateTotalPrice(List items) => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int _calculateTotalItems(List items) => items.fold<int>(0, (sum, item) => sum + item.quantity as int);

  int? getCartSupplierId() {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      if (items.isNotEmpty) return items.first.item.supplierId;
    } else if (state is CartOperationSuccess) {
      final items = (state as CartOperationSuccess).items;
      if (items.isNotEmpty) return items.first.item.supplierId;
    }
    return null;
  }
}
