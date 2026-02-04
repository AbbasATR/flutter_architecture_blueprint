part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class RequestOtpSubmitted extends LoginEvent {
  final String phoneNumber;

  const RequestOtpSubmitted(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

final class VerifyOtpSubmitted extends LoginEvent {
  final String phoneNumber;
  final String pinCode;

  const VerifyOtpSubmitted(this.phoneNumber, this.pinCode);

  @override
  List<Object> get props => [phoneNumber, pinCode];
}
