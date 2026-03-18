import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> requestOtp(String phoneNumber);
  Future<Either<Failure, AuthTokens>> verifyOtp(String phoneNumber, String pinCode);
  Future<Either<Failure, AuthTokens>> refreshToken();
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, AuthSession>> checkAuthStatus();
  Future<Either<Failure, AppBootstrap>> getAppBootstrap(String accessToken);
}
