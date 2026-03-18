import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/add_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/clear_cart.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/delete_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_item_by_id.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/get_cart_items.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/usecases/update_cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
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

  final GetCartItems getCartItems;
  final AddCartItem addCartItem;
  final UpdateCartItem updateCartItem;
  final DeleteCartItem deleteCartItem;
  final ClearCart clearCart;
  final GetCartItemById getCartItemById;

  Future<void> _emitCartSnapshot(Emitter<CartState> emit, {String? message}) async {
    final result = await getCartItems(NoParams());
    result.fold((failure) => emit(CartError(failure.message)), (items) {
      final totalPrice = _calculateTotalPrice(items);
      final totalItems = _calculateTotalItems(items);
      if (message != null) {
        emit(CartOperationSuccess(
          message: message,
          items: items,
          totalPrice: totalPrice,
          totalItems: totalItems,
        ));
        return;
      }
      emit(CartLoaded(items: items, totalPrice: totalPrice, totalItems: totalItems));
    });
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    await _emitCartSnapshot(emit);
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final result = await addCartItem(AddCartItemParams(event.item));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) => _emitCartSnapshot(emit, message: 'Item added to cart'),
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItemEvent event, Emitter<CartState> emit) async {
    final result = await updateCartItem(UpdateCartItemParams(event.item));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) => _emitCartSnapshot(emit),
    );
  }

  Future<void> _onDeleteCartItem(DeleteCartItemEvent event, Emitter<CartState> emit) async {
    final result = await deleteCartItem(DeleteCartItemParams(event.id));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) => _emitCartSnapshot(emit),
    );
  }

  Future<void> _onIncrementQuantity(IncrementQuantityEvent event, Emitter<CartState> emit) async {
    final itemResult = await getCartItemById(GetCartItemByIdParams(event.id));
    await itemResult.fold((failure) async => emit(CartError(failure.message)), (item) async {
      if (item == null) return;
      await _updateQuantity(emit, item.copyWith(quantity: item.quantity + 1));
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
      await _updateQuantity(emit, item.copyWith(quantity: item.quantity - 1));
    });
  }

  Future<void> _updateQuantity(Emitter<CartState> emit, CartItem item) async {
    final result = await updateCartItem(UpdateCartItemParams(item));
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) => _emitCartSnapshot(emit),
    );
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    final result = await clearCart(NoParams());
    await result.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async => emit(const CartLoaded(items: [], totalPrice: 0, totalItems: 0)),
    );
  }

  Future<void> _onReplaceCartAndAdd(ReplaceCartAndAddEvent event, Emitter<CartState> emit) async {
    final clearResult = await clearCart(NoParams());
    await clearResult.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async {
        final addResult = await addCartItem(AddCartItemParams(event.item));
        await addResult.fold(
          (failure) async => emit(CartError(failure.message)),
          (_) => _emitCartSnapshot(emit, message: 'Cart replaced with new item'),
        );
      },
    );
  }

  double _calculateTotalPrice(List<CartItem> items) => items.fold(0, (sum, item) => sum + item.totalPrice);
  int _calculateTotalItems(List<CartItem> items) => items.fold(0, (sum, item) => sum + item.quantity);
  int? getCartSupplierId() => state is CartLoaded && (state as CartLoaded).items.isNotEmpty ? (state as CartLoaded).items.first.item.supplierId : null;
}
