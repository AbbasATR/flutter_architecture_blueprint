import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/usecases/update_user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUser updateUser;

  UserCubit({required this.updateUser}) : super(UserInitial());

  Future<void> updateUserProfile(User user) async {
    emit(UserLoading());
    final result = await updateUser(UpdateUserParams(user: user));
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (updatedUser) => emit(UserLoaded(updatedUser)),
    );
  }

  String _mapFailureToMessage(failure) {
    return failure.message ?? 'An error occurred. Please try again.';
  }
}
