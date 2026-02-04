import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';

/// Repository interface for item data operations.
abstract class ItemRepository {
  /// Get items for a specific supplier.
  ///
  /// Returns a list of items belonging to the supplier with [supplierId].
  /// Returns [ServerFailure] if the operation fails.
  Future<Either<Failure, List<Item>>> getItemsBySupplierId(int supplierId);

  /// Get a single item by ID.
  ///
  /// Returns the item with the specified [id].
  /// Returns [ServerFailure] if not found or operation fails.
  Future<Either<Failure, Item>> getItemById(int id);

  /// Get featured items for a supplier.
  ///
  /// Returns a list of currently featured items for the supplier.
  /// Returns [ServerFailure] if the operation fails.
  Future<Either<Failure, List<Item>>> getFeaturedItemsBySupplierId(
    int supplierId,
  );
}
