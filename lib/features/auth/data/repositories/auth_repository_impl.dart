import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/error/error_mapper.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/network/network_info.dart';
import 'package:flutter_architecture_blueprint/core/services/secure_storage_service.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remoteDataSource, required this.networkInfo, required this.secureStorage});

  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SecureStorageService secureStorage;

  @override
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await remoteDataSource.requestOtp(phoneNumber);
      return const Right(unit);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> verifyOtp(String phoneNumber, String pinCode) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final tokens = await remoteDataSource.verifyOtp(phoneNumber, pinCode);
      await secureStorage.saveRefreshToken(tokens.refreshToken);
      return Right(tokens);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    final storedRefreshToken = await secureStorage.getRefreshToken();
    if (storedRefreshToken == null) {
      return const Left(UnauthorizedFailure('No refresh token found'));
    }
    try {
      final tokens = await remoteDataSource.refreshToken(storedRefreshToken);
      await secureStorage.saveRefreshToken(tokens.refreshToken);
      return Right(tokens);
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> checkAuthStatus() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    final refreshTokenValue = await secureStorage.getRefreshToken();
    if (refreshTokenValue == null) {
      return const Left(UnauthorizedFailure('No refresh token found'));
    }
    try {
      final tokens = await remoteDataSource.refreshToken(refreshTokenValue);
      await secureStorage.saveRefreshToken(tokens.refreshToken);
      final appBootstrap = await remoteDataSource.appStart(tokens.accessToken);
      return Right(AuthSession(appBootstrap: appBootstrap, accessToken: tokens.accessToken));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, AppBootstrap>> getAppBootstrap(String accessToken) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.appStart(accessToken));
    } catch (error) {
      return Left(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }
      await secureStorage.deleteAllTokens();
      return const Right(unit);
    } catch (error) {
      await secureStorage.deleteAllTokens();
      return Left(mapExceptionToFailure(error));
    }
  }
}
