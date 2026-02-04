import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/repositories/item_repository.dart';

/// Use case for getting items by supplier ID.
class GetItemsBySupplierId
    implements UseCase<List<Item>, GetItemsBySupplierIdParams> {
  final ItemRepository repository;

  GetItemsBySupplierId(this.repository);

  @override
  Future<Either<Failure, List<Item>>> call(
    GetItemsBySupplierIdParams params,
  ) async {
    return await repository.getItemsBySupplierId(params.supplierId);
  }
}

/// Parameters for [GetItemsBySupplierId] use case.
class GetItemsBySupplierIdParams extends Equatable {
  final int supplierId;

  const GetItemsBySupplierIdParams({required this.supplierId});

  @override
  List<Object?> get props => [supplierId];
}
