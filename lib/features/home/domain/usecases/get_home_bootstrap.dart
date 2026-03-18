import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';

import '../entities/home_bootstrap.dart';
import '../repositories/home_repository.dart';

class GetHomeBootstrapUseCase implements UseCase<HomeBootstrap, NoParams> {
  const GetHomeBootstrapUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, HomeBootstrap>> call(NoParams params) {
    return _repository.fetchHomeBootstrap();
  }
}
