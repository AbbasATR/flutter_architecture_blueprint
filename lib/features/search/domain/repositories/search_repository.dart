import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';

/// Repository interface for search operations
abstract class SearchRepository {
  /// Search for items (products/services) by query
  Future<Either<Failure, List<SearchItem>>> searchItems(String query);

  /// Search for suppliers (restaurants/shops) by query
  Future<Either<Failure, List<SearchSupplier>>> searchSuppliers(String query);

  /// Get search suggestions based on partial query
  Future<Either<Failure, List<String>>> getSearchSuggestions(String query);

  /// Save search query to history
  Future<Either<Failure, void>> saveSearchHistory(String query);

  /// Get recent search history
  Future<Either<Failure, List<String>>> getSearchHistory();

  /// Clear all search history
  Future<Either<Failure, void>> clearSearchHistory();
}
