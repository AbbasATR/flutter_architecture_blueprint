import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';

class AuthSession extends Equatable {
  final HomeBootstrap appBootstrap;
  final String accessToken;

  const AuthSession({required this.appBootstrap, required this.accessToken});

  @override
  List<Object> get props => [appBootstrap, accessToken];
}
