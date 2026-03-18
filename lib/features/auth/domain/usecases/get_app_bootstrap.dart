import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';

class GetAppBootstrap implements UseCase<AppBootstrap, GetAppBootstrapParams> {
  final AuthRepository repository;

  GetAppBootstrap(this.repository);

  @override
  Future<Either<Failure, AppBootstrap>> call(GetAppBootstrapParams params) async {
    return await repository.getAppBootstrap(params.accessToken);
  }
}

class GetAppBootstrapParams extends Equatable {
  final String accessToken;

  const GetAppBootstrapParams({required this.accessToken});

  @override
  List<Object> get props => [accessToken];
}
