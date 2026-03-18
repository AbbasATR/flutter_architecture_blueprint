import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/error/handle_dio_failure.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/models/auth_tokens_model.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/app_bootstrap.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber);
  Future<Either<Failure, AuthTokensModel>> verifyOtp(
    String phoneNumber,
    String pinCode,
  );
  Future<Either<Failure, AuthTokensModel>> refreshToken(String refreshToken);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, AppBootstrap>> appStart(String accessToken);
}

class AuthRemoteImplWithDio implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteImplWithDio(this.dioClient);

  @override
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber) async {
    try {
      await dioClient.post(
        ApiEndpoints.requestOtp,
        data: {'phoneNumber': phoneNumber},
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokensModel>> verifyOtp(
    String phoneNumber,
    String pinCode,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.verifyOtp,
        data: {'phoneNumber': phoneNumber, 'pinCode': pinCode},
      );
      final tokens = AuthTokensModel.fromJson(response.data);
      return Right(tokens);
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokensModel>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final tokens = AuthTokensModel.fromJson(response.data);
      return Right(tokens);
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AppBootstrap>> appStart(String accessToken) async {
    try {
      await dioClient.get(
        ApiEndpoints.userData,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return Right(
        AppBootstrap(
          categories: [],
          brands: [],
          savedItems: [],
          newListings: [],
        ),
      );
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await dioClient.post(ApiEndpoints.logout);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
