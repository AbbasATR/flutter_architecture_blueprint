import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/item/data/datasources/item_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/repositories/item_repository.dart';

/// Implementation of [ItemRepository].
class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource remoteDataSource;

  ItemRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Item>>> getItemsBySupplierId(
    int supplierId,
  ) async {
    try {
      final items = await remoteDataSource.getItemsBySupplierId(supplierId);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Item>> getItemById(int id) async {
    try {
      final item = await remoteDataSource.getItemById(id);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getFeaturedItemsBySupplierId(
    int supplierId,
  ) async {
    try {
      final items = await remoteDataSource.getFeaturedItemsBySupplierId(
        supplierId,
      );
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
