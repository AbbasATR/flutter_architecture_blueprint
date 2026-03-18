part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class AuthLoggedIn extends AuthEvent {
  final AppBootstrap appBootstrap;
  final String accessToken;

  const AuthLoggedIn(this.appBootstrap, this.accessToken);

  @override
  List<Object> get props => [appBootstrap, accessToken];
}

final class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}
