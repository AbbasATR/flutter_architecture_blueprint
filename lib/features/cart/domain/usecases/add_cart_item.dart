import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

class AddCartItem implements UseCase<void, AddCartItemParams> {
  AddCartItem(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(AddCartItemParams params) {
    return repository.addCartItem(params.item);
  }
}

class AddCartItemParams extends Equatable {
  const AddCartItemParams(this.item);
  final CartItem item;
  @override
  List<Object?> get props => [item];
}
