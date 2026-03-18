import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

class DeleteCartItem implements UseCase<void, DeleteCartItemParams> {
  DeleteCartItem(this.repository);
  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteCartItemParams params) {
    return repository.deleteCartItem(params.id);
  }
}

class DeleteCartItemParams extends Equatable {
  const DeleteCartItemParams(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
