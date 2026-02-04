import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/utils/snackbar_helper.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/dialogs/loading_dialog.dart';

void logoutListener(BuildContext context, LogoutState state) {
  if (state is LogoutSuccess) {
    LoadingDialog.hide(context);

    context.read<AuthBloc>().add(AuthLoggedOut());
  } else if (state is LogoutFailure) {
    LoadingDialog.hide(context);
    showAppSnackBar(context, message: state.error, isError: true);
  } else if (state is LogoutLoading) {
    LoadingDialog.show(context);
  }
}
