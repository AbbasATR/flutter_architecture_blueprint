import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _authRepository;
  CheckAuthStatusUseCase(this._authRepository);
  Future<Either<Failure, AuthSession?>> call() async {
    try {
      final result = await _authRepository.checkAuthStatus();
      return result.fold(
        (failure) => Left(failure),
        (authSession) => Right(authSession),
      );
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
