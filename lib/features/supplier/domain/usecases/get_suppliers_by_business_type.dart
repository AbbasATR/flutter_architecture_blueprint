import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/repositories/supplier_repository.dart';

/// Use case for getting suppliers by business type.
class GetSuppliersByBusinessType
    implements UseCase<List<Supplier>, GetSuppliersByBusinessTypeParams> {
  final SupplierRepository repository;

  GetSuppliersByBusinessType(this.repository);

  @override
  Future<Either<Failure, List<Supplier>>> call(
    GetSuppliersByBusinessTypeParams params,
  ) async {
    return await repository.getSuppliersByBusinessType(params.businessType);
  }
}

/// Parameters for [GetSuppliersByBusinessType] use case.
class GetSuppliersByBusinessTypeParams extends Equatable {
  final SupplierBusinessType businessType;

  const GetSuppliersByBusinessTypeParams({required this.businessType});

  @override
  List<Object?> get props => [businessType];
}
