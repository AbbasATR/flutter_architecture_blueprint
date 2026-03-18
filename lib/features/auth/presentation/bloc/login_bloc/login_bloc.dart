import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/get_app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/request_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/verify_otp.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RequestOtp requestOtpUseCase;
  final VerifyOtp verifyOtpUseCase;
  final GetAppBootstrap getAppBootstrapUseCase;

  LoginBloc({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.getAppBootstrapUseCase,
  }) : super(LoginInitial()) {
    on<RequestOtpSubmitted>(_onRequestOtpSubmitted);
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
  }

  Future<void> _onRequestOtpSubmitted(
    RequestOtpSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    if (event.phoneNumber.isEmpty) {
      emit(const LoginFailure('Please enter a phone number'));
      return;
    }

    final result = await requestOtpUseCase(
      RequestOtpParams(phoneNumber: event.phoneNumber),
    );

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (_) => emit(OtpRequested(event.phoneNumber)),
    );
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    if (event.phoneNumber.isEmpty || event.pinCode.isEmpty) {
      emit(const LoginFailure('Phone number and PIN code are required'));
      return;
    }

    final result = await verifyOtpUseCase(
      VerifyOtpParams(phoneNumber: event.phoneNumber, pinCode: event.pinCode),
    );

    await result.fold((failure) async => emit(LoginFailure(failure.message)), (
      tokens,
    ) async {
      // Get app bootstrap with the access token
      final sessionResult = await getAppBootstrapUseCase(
        GetAppBootstrapParams(accessToken: tokens.accessToken),
      );

      sessionResult.fold(
        (failure) => emit(LoginFailure(failure.message)),
        (appBootstrap) => emit(LoginSuccess(tokens, appBootstrap)),
      );
    });
  }
}
