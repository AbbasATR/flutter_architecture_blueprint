import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SearchItem>>> searchItems(String query) async {
    try {
      final items = await remoteDataSource.searchItems(query);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure('Failed to search items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SearchSupplier>>> searchSuppliers(
    String query,
  ) async {
    try {
      final suppliers = await remoteDataSource.searchSuppliers(query);
      return Right(suppliers);
    } catch (e) {
      return Left(ServerFailure('Failed to search suppliers: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(
    String query,
  ) async {
    // TODO: Implement search suggestions
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> saveSearchHistory(String query) async {
    // TODO: Implement save search history
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<String>>> getSearchHistory() async {
    // TODO: Implement get search history
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    // TODO: Implement clear search history
    return const Right(null);
  }
}
