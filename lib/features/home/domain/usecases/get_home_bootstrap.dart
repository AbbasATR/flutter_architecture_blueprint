import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/repositories/home_repository.dart';

class GetHomeBootstrapUseCase implements UseCase<AppBootstrap, NoParams> {
  const GetHomeBootstrapUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, AppBootstrap>> call(NoParams params) {
    return _repository.fetchHomeBootstrap();
  }
}
