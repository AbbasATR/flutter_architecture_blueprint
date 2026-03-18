import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

class GetCartItems implements UseCase<List<CartItem>, NoParams> {
  GetCartItems(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) {
    return repository.getCartItems();
  }
}
