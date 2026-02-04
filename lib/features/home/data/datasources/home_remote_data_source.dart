import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/error/handle_dio_failure.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_bootstrap_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, HomeBootstrapModel>> fetchHomeBootstrap();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, HomeBootstrapModel>> fetchHomeBootstrap() async {
    try {
      final response = await dioClient.get(ApiEndpoints.homeBootstrap);
      final data = response.data as Map<String, dynamic>;
      return Right(HomeBootstrapModel.fromJson(data));
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
