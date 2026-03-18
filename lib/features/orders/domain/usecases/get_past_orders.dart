import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';

class GetPastOrders implements UseCase<List<Order>, NoParams> {
  GetPastOrders(this.repository);
  final OrderRepository repository;

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) {
    return repository.getPastOrders();
  }
}
