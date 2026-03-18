import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';

class ClearCart implements UseCase<void, NoParams> {
  ClearCart(this.repository);
  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearCart();
  }
}
