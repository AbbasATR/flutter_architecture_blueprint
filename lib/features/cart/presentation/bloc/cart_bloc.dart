import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';

/// BLoC for managing cart state
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(const CartInitial()) {
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

    final result = await repository.getCartItems();

    result.fold((failure) => emit(CartError(failure.message)), (items) {
      final totalPrice = _calculateTotalPrice(items);
      final totalItems = _calculateTotalItems(items);
      emit(
        CartLoaded(
          items: items,
          totalPrice: totalPrice,
          totalItems: totalItems,
        ),
      );
    });
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await repository.addCartItem(event.item);

    await result.fold((failure) async => emit(CartError(failure.message)), (
      _,
    ) async {
      // Reload cart after adding
      final cartResult = await repository.getCartItems();
      cartResult.fold((failure) => emit(CartError(failure.message)), (items) {
        final totalPrice = _calculateTotalPrice(items);
        final totalItems = _calculateTotalItems(items);
        emit(
          CartOperationSuccess(
            message: 'Item added to cart',
            items: items,
            totalPrice: totalPrice,
            totalItems: totalItems,
          ),
        );
      });
    });
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await repository.updateCartItem(event.item);

    await result.fold((failure) async => emit(CartError(failure.message)), (
      _,
    ) async {
      final cartResult = await repository.getCartItems();
      cartResult.fold((failure) => emit(CartError(failure.message)), (items) {
        final totalPrice = _calculateTotalPrice(items);
        final totalItems = _calculateTotalItems(items);
        emit(
          CartLoaded(
            items: items,
            totalPrice: totalPrice,
            totalItems: totalItems,
          ),
        );
      });
    });
  }

  Future<void> _onDeleteCartItem(
    DeleteCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await repository.deleteCartItem(event.id);

    await result.fold((failure) async => emit(CartError(failure.message)), (
      _,
    ) async {
      final cartResult = await repository.getCartItems();
      cartResult.fold((failure) => emit(CartError(failure.message)), (items) {
        final totalPrice = _calculateTotalPrice(items);
        final totalItems = _calculateTotalItems(items);
        emit(
          CartLoaded(
            items: items,
            totalPrice: totalPrice,
            totalItems: totalItems,
          ),
        );
      });
    });
  }

  Future<void> _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final itemResult = await repository.getCartItemById(event.id);

    await itemResult.fold((failure) async => emit(CartError(failure.message)), (
      item,
    ) async {
      if (item != null) {
        final updatedItem = item.copyWith(quantity: item.quantity + 1);
        final result = await repository.updateCartItem(updatedItem);

        await result.fold((failure) async => emit(CartError(failure.message)), (
          _,
        ) async {
          final cartResult = await repository.getCartItems();
          cartResult.fold((failure) => emit(CartError(failure.message)), (
            items,
          ) {
            final totalPrice = _calculateTotalPrice(items);
            final totalItems = _calculateTotalItems(items);
            emit(
              CartLoaded(
                items: items,
                totalPrice: totalPrice,
                totalItems: totalItems,
              ),
            );
          });
        });
      }
    });
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final itemResult = await repository.getCartItemById(event.id);

    await itemResult.fold((failure) async => emit(CartError(failure.message)), (
      item,
    ) async {
      if (item != null) {
        if (item.quantity <= 1) {
          // Delete item if quantity is 1
          add(DeleteCartItemEvent(event.id));
        } else {
          final updatedItem = item.copyWith(quantity: item.quantity - 1);
          final result = await repository.updateCartItem(updatedItem);

          await result.fold(
            (failure) async => emit(CartError(failure.message)),
            (_) async {
              final cartResult = await repository.getCartItems();
              cartResult.fold((failure) => emit(CartError(failure.message)), (
                items,
              ) {
                final totalPrice = _calculateTotalPrice(items);
                final totalItems = _calculateTotalItems(items);
                emit(
                  CartLoaded(
                    items: items,
                    totalPrice: totalPrice,
                    totalItems: totalItems,
                  ),
                );
              });
            },
          );
        }
      }
    });
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await repository.clearCart();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded(items: [], totalPrice: 0, totalItems: 0)),
    );
  }

  Future<void> _onReplaceCartAndAdd(
    ReplaceCartAndAddEvent event,
    Emitter<CartState> emit,
  ) async {
    // Clear cart first
    final clearResult = await repository.clearCart();

    await clearResult.fold(
      (failure) async => emit(CartError(failure.message)),
      (_) async {
        // Add new item
        final addResult = await repository.addCartItem(event.item);

        await addResult.fold(
          (failure) async => emit(CartError(failure.message)),
          (_) async {
            // Reload cart
            final cartResult = await repository.getCartItems();
            cartResult.fold((failure) => emit(CartError(failure.message)), (
              items,
            ) {
              final totalPrice = _calculateTotalPrice(items);
              final totalItems = _calculateTotalItems(items);
              emit(
                CartOperationSuccess(
                  message: 'Cart replaced with new item',
                  items: items,
                  totalPrice: totalPrice,
                  totalItems: totalItems,
                ),
              );
            });
          },
        );
      },
    );
  }

  double _calculateTotalPrice(List items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int _calculateTotalItems(List items) {
    return items.fold<int>(0, (sum, item) => sum + item.quantity as int);
  }

  /// Get supplier ID from cart (null if cart is empty)
  int? getCartSupplierId() {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      if (items.isNotEmpty) {
        return items.first.item.supplierId;
      }
    } else if (state is CartOperationSuccess) {
      final items = (state as CartOperationSuccess).items;
      if (items.isNotEmpty) {
        return items.first.item.supplierId;
      }
    }
    return null;
  }
}
