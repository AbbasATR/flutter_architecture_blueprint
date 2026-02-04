import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AuthContextExtension on BuildContext {
  bool get isAuthenticated {
    return select<AuthBloc, bool>((bloc) {
      final state = bloc.state;
      return state is AuthAuthenticated;
    });
  }
}
