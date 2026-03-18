import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/network/network_info.dart';
import 'package:flutter_architecture_blueprint/core/services/secure_storage_service.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/app_bootstrap.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.requestOtp(phoneNumber);
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> verifyOtp(
    String phoneNumber,
    String pinCode,
  ) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.verifyOtp(phoneNumber, pinCode);
      return result.fold((failure) => Left(failure), (tokens) async {
        // Save only refresh token to secure storage
        await secureStorage.saveRefreshToken(tokens.refreshToken);
        return Right(tokens);
      });
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    if (await networkInfo.isConnected) {
      final storedRefreshToken = await secureStorage.getRefreshToken();

      if (storedRefreshToken == null) {
        return Left(UnauthorizedFailure('No refresh token found'));
      }

      final result = await remoteDataSource.refreshToken(storedRefreshToken);
      return result.fold((failure) => Left(failure), (tokens) async {
        // Update only refresh token in secure storage
        await secureStorage.saveRefreshToken(tokens.refreshToken);
        return Right(tokens);
      });
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthSession>> checkAuthStatus() async {
    if (await networkInfo.isConnected) {
      // Get refresh token from secure storage
      final refreshToken = await secureStorage.getRefreshToken();

      if (refreshToken == null) {
        return Left(UnauthorizedFailure('No refresh token found'));
      }

      // Use refresh token to get new access token
      final tokenResult = await remoteDataSource.refreshToken(refreshToken);

      return await tokenResult.fold((failure) => Left(failure), (tokens) async {
        // Save new refresh token
        await secureStorage.saveRefreshToken(tokens.refreshToken);

        // Get user session with new access token
        final userResult = await remoteDataSource.appStart(tokens.accessToken);
        return userResult.fold(
          (failure) => Left(failure),
          (appBootstrap) => Right(
            AuthSession(
              appBootstrap: appBootstrap,
              accessToken: tokens.accessToken,
            ),
          ),
        );
      });
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AppBootstrap>> getAppBootstrap(
    String accessToken,
  ) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.appStart(accessToken);
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.signOut();
      return result.fold((failure) => Left(failure), (_) async {
        // Clear tokens from secure storage
        await secureStorage.deleteAllTokens();
        return const Right(unit);
      });
    } else {
      // Even if offline, clear local tokens
      await secureStorage.deleteAllTokens();
      return Left(NetworkFailure());
    }
  }
}
