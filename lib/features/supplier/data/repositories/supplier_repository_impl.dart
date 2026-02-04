import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/supplier/data/datasources/supplier_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/repositories/supplier_repository.dart';

/// Implementation of [SupplierRepository].
class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDataSource remoteDataSource;

  SupplierRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliersByBusinessType(
    SupplierBusinessType businessType,
  ) async {
    try {
      final suppliers = await remoteDataSource.getSuppliersByBusinessType(
        businessType,
      );
      return Right(suppliers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Supplier>> getSupplierById(int id) async {
    try {
      final supplier = await remoteDataSource.getSupplierById(id);
      return Right(supplier);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Supplier>>> getAllSuppliers() async {
    try {
      final suppliers = await remoteDataSource.getAllSuppliers();
      return Right(suppliers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
