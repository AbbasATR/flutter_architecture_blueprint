import '../entities/home_bootstrap.dart';
import '../repositories/home_repository.dart';

class GetHomeBootstrapUseCase {
  const GetHomeBootstrapUseCase(this._repository);

  final HomeRepository _repository;

  Future<HomeBootstrap> call() => _repository.fetchHomeBootstrap();
}
