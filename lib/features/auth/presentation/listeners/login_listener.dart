import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/utils/snackbar_helper.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/dialogs/loading_dialog.dart';

void loginListener(
  BuildContext context,
  LoginState state,
  TextEditingController passwordController,
) {
  if (state is OtpRequested) {
    LoadingDialog.hide(context);
    // Navigate to PIN code screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PinCodeScreen(phoneNumber: state.phoneNumber),
    //   ),
    // );
  }
  if (state is LoginSuccess) {
    LoadingDialog.hide(context);
    passwordController.clear();
    // Dispatch AuthLoggedIn with appBootstrap and accessToken from login success
    context.read<AuthBloc>().add(
      AuthLoggedIn(state.appBootstrap, state.tokens.accessToken),
    );
  }
  if (state is LoginFailure) {
    LoadingDialog.hide(context);
    showAppSnackBar(context, message: state.message, isError: true);
  }
  if (state is LoginLoading) {
    LoadingDialog.show(context);
  }
}
