import 'package:equatable/equatable.dart';

abstract class LoginEvents extends Equatable {}

class LoginSendOtpEvent extends LoginEvents {
  final Map requestData;
  LoginSendOtpEvent({required this.requestData});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class FirebaseVerificationFailedEvent extends LoginEvents {
  final String message;
  final bool isResendOtp;

  FirebaseVerificationFailedEvent(
      {required this.message, required this.isResendOtp});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FirebaseVerificationCompletedEvent extends LoginEvents {
  final Map requestData;
  final bool isResendOtp;

  FirebaseVerificationCompletedEvent(
      {required this.requestData, required this.isResendOtp});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginVerifyOtpEvent extends LoginEvents {
  final Map requestData;

  LoginVerifyOtpEvent({required this.requestData});
  @override
  List<Object?> get props => throw UnimplementedError();
}
