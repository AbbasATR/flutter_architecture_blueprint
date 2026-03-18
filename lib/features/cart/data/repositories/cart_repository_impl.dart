import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/error_mapper.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required this.localDataSource});

  final CartLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final models = await localDataSource.getCartItems();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> addCartItem(CartItem item) async {
    try {
      await localDataSource.addCartItem(CartItemModel.fromEntity(item));
      return const Right(null);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(CartItem item) async {
    try {
      await localDataSource.updateCartItem(CartItemModel.fromEntity(item));
      return const Right(null);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCartItem(String id) async {
    try {
      await localDataSource.deleteCartItem(id);
      return const Right(null);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, CartItem?>> getCartItemById(String id) async {
    try {
      final model = await localDataSource.getCartItemById(id);
      return Right(model?.toEntity());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }
}
