import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemById implements UseCase<CartItem?, GetCartItemByIdParams> {
  GetCartItemById(this.repository);
  final CartRepository repository;

  @override
  Future<Either<Failure, CartItem?>> call(GetCartItemByIdParams params) {
    return repository.getCartItemById(params.id);
  }
}

class GetCartItemByIdParams extends Equatable {
  const GetCartItemByIdParams(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
