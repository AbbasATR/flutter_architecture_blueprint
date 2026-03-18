import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/error/error_mapper.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/network/network_info.dart';
import 'package:flutter_architecture_blueprint/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, AppBootstrap>> fetchHomeBootstrap() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.fetchHomeBootstrap();
      return Right(model.toEntity());
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }
}
