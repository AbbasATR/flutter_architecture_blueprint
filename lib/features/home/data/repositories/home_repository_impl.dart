import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/network/network_info.dart';
import 'package:flutter_architecture_blueprint/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, HomeBootstrap>> fetchHomeBootstrap() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.fetchHomeBootstrap();
    }

    return Left(NetworkFailure());
  }
}
