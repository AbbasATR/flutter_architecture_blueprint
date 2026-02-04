import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/sign_out.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final SignOutUseCase signOutUseCase;
  LogoutBloc(this.signOutUseCase) : super(LogoutInitial()) {
    on<LogoutEvent>((event, emit) async {
      if (event is LogoutRequested) {
        await _onLogoutRequested(event, emit);
      }
    });
  }
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(LogoutFailure(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
