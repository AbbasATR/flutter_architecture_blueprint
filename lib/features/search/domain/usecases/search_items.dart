import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/repositories/search_repository.dart';

/// Use case for searching items
class SearchItems implements UseCase<List<SearchItem>, SearchItemsParams> {
  final SearchRepository repository;

  SearchItems(this.repository);

  @override
  Future<Either<Failure, List<SearchItem>>> call(
    SearchItemsParams params,
  ) async {
    return await repository.searchItems(params.query);
  }
}

class SearchItemsParams extends Equatable {
  final String query;

  const SearchItemsParams({required this.query});

  @override
  List<Object?> get props => [query];
}
