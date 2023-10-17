import 'package:equatable/equatable.dart';

abstract class LoginStates extends Equatable {}

class LoginInitialState extends LoginStates {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginSendOtpLoadingState extends LoginStates {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginSendOtpLoadedState extends LoginStates {
  final Map responseData;

  LoginSendOtpLoadedState({required this.responseData});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginSendOtpErrorState extends LoginStates {
  final String message;
  LoginSendOtpErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class FirebaseResendVerificationCompletedState extends LoginStates {
  final Map responseData;

  FirebaseResendVerificationCompletedState({required this.responseData});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FirebaseVerificationCompletedState extends LoginStates {
  final Map responseData;

  FirebaseVerificationCompletedState({required this.responseData});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class VerifyOtpLoadingState extends LoginStates {
  @override
  List<Object?> get props => throw UnimplementedError();
}

//ignore: must_be_immutable
class VerifyOtpLoadedState extends LoginStates {
  final Map responseData;
  VerifyOtpLoadedState({required this.responseData});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class VerifyOtpErrorState extends LoginStates {
  final String message;
  VerifyOtpErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}
