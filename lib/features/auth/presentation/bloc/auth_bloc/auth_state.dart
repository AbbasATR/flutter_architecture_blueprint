part of 'auth_bloc.dart';


sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final AppBootstrap appBootstrap;
  final String accessToken;

  const AuthAuthenticated(this.appBootstrap, this.accessToken);

  @override
  List<Object> get props => [appBootstrap, accessToken];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
