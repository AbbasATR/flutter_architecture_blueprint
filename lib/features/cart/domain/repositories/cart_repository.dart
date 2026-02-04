import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';

/// Repository interface for cart operations
abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addCartItem(CartItem item);
  Future<Either<Failure, void>> updateCartItem(CartItem item);
  Future<Either<Failure, void>> deleteCartItem(String id);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, CartItem?>> getCartItemById(String id);
}
