import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';

/// Repository interface for supplier data operations.
abstract class SupplierRepository {
  /// Get suppliers filtered by business type.
  ///
  /// Returns a list of suppliers matching the specified [businessType].
  /// Returns [ServerFailure] if the operation fails.
  Future<Either<Failure, List<Supplier>>> getSuppliersByBusinessType(
    SupplierBusinessType businessType,
  );

  /// Get a single supplier by ID.
  ///
  /// Returns the supplier with the specified [id].
  /// Returns [ServerFailure] if not found or operation fails.
  Future<Either<Failure, Supplier>> getSupplierById(int id);

  /// Get all suppliers.
  ///
  /// Returns all available suppliers.
  /// Returns [ServerFailure] if the operation fails.
  Future<Either<Failure, List<Supplier>>> getAllSuppliers();
}
