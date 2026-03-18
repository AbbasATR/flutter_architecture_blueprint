part of 'home_bootstrap_cubit.dart';

sealed class HomeBootstrapState extends Equatable {
  const HomeBootstrapState();

  @override
  List<Object> get props => [];
}

final class HomeBootstrapInitial extends HomeBootstrapState {}

final class HomeBootstrapLoading extends HomeBootstrapState {}

final class HomeBootstrapLoaded extends HomeBootstrapState {
  final AppBootstrap bootstrap;

  const HomeBootstrapLoaded(this.bootstrap);

  @override
  List<Object> get props => [bootstrap];
}

final class HomeBootstrapError extends HomeBootstrapState {
  final String message;

  const HomeBootstrapError(this.message);

  @override
  List<Object> get props => [message];
}
