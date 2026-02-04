import '../entities/home_bootstrap.dart';

abstract class HomeRepository {
  Future<HomeBootstrap> fetchHomeBootstrap();
}
