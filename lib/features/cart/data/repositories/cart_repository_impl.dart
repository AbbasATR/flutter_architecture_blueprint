import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

/// Implementation of CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCartItem(CartItem item) async {
    try {
      final model = CartItemModel.fromEntity(item);
      await localDataSource.addCartItem(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(CartItem item) async {
    try {
      final model = CartItemModel.fromEntity(item);
      await localDataSource.updateCartItem(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCartItem(String id) async {
    try {
      await localDataSource.deleteCartItem(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItem?>> getCartItemById(String id) async {
    try {
      final item = await localDataSource.getCartItemById(id);
      return Right(item);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
