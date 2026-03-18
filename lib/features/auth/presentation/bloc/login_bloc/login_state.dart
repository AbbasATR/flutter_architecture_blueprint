part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class OtpRequested extends LoginState {
  final String phoneNumber;

  const OtpRequested(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

final class LoginSuccess extends LoginState {
  final AuthTokens tokens;
  final AppBootstrap appBootstrap;

  const LoginSuccess(this.tokens, this.appBootstrap);

  @override
  List<Object> get props => [tokens, appBootstrap];
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object> get props => [message];
}
