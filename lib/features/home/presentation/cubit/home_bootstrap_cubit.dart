import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/usecases/get_home_bootstrap.dart';

part 'home_bootstrap_state.dart';

class HomeBootstrapCubit extends Cubit<HomeBootstrapState> {
  final GetHomeBootstrapUseCase getHomeBootstrapUseCase;

  HomeBootstrapCubit(this.getHomeBootstrapUseCase)
    : super(HomeBootstrapInitial());

  Future<void> loadHomeBootstrap() async {
    try {
      emit(HomeBootstrapLoading());
      final result = await getHomeBootstrapUseCase(const NoParams());
      result.fold(
        (failure) => emit(HomeBootstrapError(failure.message)),
        (bootstrap) => emit(HomeBootstrapLoaded(bootstrap)),
      );
    } catch (e) {
      emit(HomeBootstrapError(e.toString()));
    }
  }

  void retry() {
    loadHomeBootstrap();
  }
}
