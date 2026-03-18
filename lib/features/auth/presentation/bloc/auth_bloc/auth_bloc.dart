import 'package:flutter_architecture_blueprint/features/auth/domain/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/check_auth_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  AuthBloc(this._checkAuthStatusUseCase) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckRequested) {
        final result = await _checkAuthStatusUseCase();
        emit(AuthLoading());
        await Future.delayed(const Duration(seconds: 2));
        result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (authSession) => authSession != null
              ? emit(
                  AuthAuthenticated(
                    authSession.appBootstrap,
                    authSession.accessToken,
                  ),
                )
              : emit(AuthUnauthenticated()),
        );
      } else if (event is AuthLoggedIn) {
        emit(AuthAuthenticated(event.appBootstrap, event.accessToken));
      } else if (event is AuthLoggedOut) {
        emit(AuthUnauthenticated());
      }
    });
  }
}
