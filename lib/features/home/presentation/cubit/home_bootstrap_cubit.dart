import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/usecases/get_home_bootstrap.dart';

part 'home_bootstrap_state.dart';

class HomeBootstrapCubit extends Cubit<HomeBootstrapState> {
  HomeBootstrapCubit(this.getHomeBootstrapUseCase) : super(HomeBootstrapInitial());

  final GetHomeBootstrapUseCase getHomeBootstrapUseCase;

  Future<void> loadHomeBootstrap() async {
    emit(HomeBootstrapLoading());
    final result = await getHomeBootstrapUseCase(NoParams());
    result.fold(
      (failure) => emit(HomeBootstrapError(failure.message)),
      (bootstrap) => emit(HomeBootstrapLoaded(bootstrap)),
    );
  }

  void retry() => loadHomeBootstrap();
}
