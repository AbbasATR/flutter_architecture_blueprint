import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_bootstrap_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeBootstrapModel> fetchHomeBootstrap();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this.dioClient);

  final DioClient dioClient;

  @override
  Future<HomeBootstrapModel> fetchHomeBootstrap() async {
    try {
      final response = await dioClient.get(ApiEndpoints.homeBootstrap);
      final data = response.data as Map<String, dynamic>;
      return HomeBootstrapModel.fromJson(data);
    } on DioException catch (error) {
      final code = error.response?.statusCode;
      if (code == 401) throw UnauthorizedException('Unauthorized');
      if (code == 400) throw ValidationException('Invalid request');
      if (error.type == DioExceptionType.connectionError || error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.sendTimeout) {
        throw NetworkException(error.message ?? 'Network error');
      }
      throw ServerException(error.message ?? 'Unexpected server error');
    }
  }
}
