import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/models/auth_tokens_model.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_bootstrap_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp(String phoneNumber);
  Future<AuthTokensModel> verifyOtp(String phoneNumber, String pinCode);
  Future<AuthTokensModel> refreshToken(String refreshToken);
  Future<void> signOut();
  Future<AppBootstrap> appStart(String accessToken);
}

class AuthRemoteImplWithDio implements AuthRemoteDataSource {
  AuthRemoteImplWithDio(this.dioClient);
  final DioClient dioClient;

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      await dioClient.post(ApiEndpoints.requestOtp, data: {'phoneNumber': phoneNumber});
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  @override
  Future<AuthTokensModel> verifyOtp(String phoneNumber, String pinCode) async {
    try {
      final response = await dioClient.post(ApiEndpoints.verifyOtp, data: {'phoneNumber': phoneNumber, 'pinCode': pinCode});
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.post(ApiEndpoints.refreshToken, data: {'refreshToken': refreshToken});
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  @override
  Future<AppBootstrap> appStart(String accessToken) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.homeBootstrap,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final data = response.data as Map<String, dynamic>;
      return HomeBootstrapModel.fromJson(data).toEntity();
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await dioClient.post(ApiEndpoints.logout);
    } on DioException catch (error) {
      throw _mapDio(error);
    }
  }

  Exception _mapDio(DioException error) {
    final code = error.response?.statusCode;
    if (code == 401) return UnauthorizedException('Unauthorized');
    if (code == 400) return ValidationException('Invalid request');
    if (error.type == DioExceptionType.connectionError || error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.sendTimeout) {
      return NetworkException(error.message ?? 'Network error');
    }
    return ServerException(error.message ?? 'Unexpected server error');
  }
}
