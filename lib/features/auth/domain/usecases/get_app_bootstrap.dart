import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';

class GetAppBootstrap implements UseCase<AppBootstrap, GetAppBootstrapParams> {
  GetAppBootstrap(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, AppBootstrap>> call(GetAppBootstrapParams params) {
    return repository.getAppBootstrap(params.accessToken);
  }
}

class GetAppBootstrapParams extends Equatable {
  const GetAppBootstrapParams({required this.accessToken});
  final String accessToken;
  @override
  List<Object> get props => [accessToken];
}
