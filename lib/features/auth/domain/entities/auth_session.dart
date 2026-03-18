import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';

class AuthSession extends Equatable {
  const AuthSession({required this.appBootstrap, required this.accessToken});

  final AppBootstrap appBootstrap;
  final String accessToken;

  @override
  List<Object> get props => [appBootstrap, accessToken];
}
