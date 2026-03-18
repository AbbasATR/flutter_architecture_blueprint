import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/app_bootstrap.dart';

class AuthSession extends Equatable {
  final AppBootstrap appBootstrap;
  final String accessToken;

  const AuthSession({required this.appBootstrap, required this.accessToken});

  @override
  List<Object> get props => [appBootstrap, accessToken];
}
