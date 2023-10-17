import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_event.dart';
import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_state.dart';
import 'package:example/auth_dashboard/phone_auth/repository/phone_auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginRepository loginRepository;
  String? verifiedId;

  LoginStates get initialState => LoginInitialState();

  LoginBloc({required this.loginRepository}) : super(LoginInitialState()) {
    on<LoginSendOtpEvent>((event, emit) async {
      emit(LoginSendOtpLoadingState());
      try {
        // await loginRepository.verifyFirebaseAuthOtp(event.requestData);
      } catch (e) {
        emit(LoginSendOtpErrorState(message: e.toString()));
      }
    });

    on<FirebaseVerificationCompletedEvent>((event, emit) async {
      if (event.isResendOtp == true) {
        emit(FirebaseResendVerificationCompletedState(
            responseData: event.requestData));
      } else {
        emit(FirebaseVerificationCompletedState(
            responseData: event.requestData));
      }
    });

    on<LoginVerifyOtpEvent>((event, emit) async {
      emit(VerifyOtpLoadingState());

      final verifyOtpResponse =
          await loginRepository.verifyFirebaseAuthOtp(event.requestData);

      if (verifyOtpResponse != null) {
        emit(VerifyOtpLoadedState(responseData: verifyOtpResponse));
      } else {
        emit(VerifyOtpErrorState(message: "verifyOtpErrorMessage"));
      }

      // } catch (e) {
      //   emit(VerifyOtpErrorState(message: e.toString()));
      // }
    });
  }
}
