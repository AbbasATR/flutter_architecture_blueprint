import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/repositories/search_repository.dart';

/// Use case for searching suppliers
class SearchSuppliers
    implements UseCase<List<SearchSupplier>, SearchSuppliersParams> {
  final SearchRepository repository;

  SearchSuppliers(this.repository);

  @override
  Future<Either<Failure, List<SearchSupplier>>> call(
    SearchSuppliersParams params,
  ) async {
    return await repository.searchSuppliers(params.query);
  }
}

class SearchSuppliersParams extends Equatable {
  final String query;

  const SearchSuppliersParams({required this.query});

  @override
  List<Object?> get props => [query];
}
