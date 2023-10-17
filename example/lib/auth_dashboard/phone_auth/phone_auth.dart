import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_event.dart';
import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_state.dart';
import 'package:example/auth_dashboard/phone_auth/otp_screen.dart';
import 'package:example/auth_dashboard/phone_auth/repository/phone_auth_repo.dart';
import 'package:firebase_auth_utility/firebase_auth_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();

    //requestSmsReadPermission();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Auth')),
      body: BlocConsumer<LoginBloc, LoginStates>(
        builder: (BuildContext context, LoginStates state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Get OTP
                TextFormField(
                  controller: _phoneController,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9/]"), allow: true),
                    LengthLimitingTextInputFormatter(10)
                  ],
                  maxLength: 10,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      filled: true,
                      prefix: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          '+91',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      counter: const Text(''),
                      fillColor: Colors.grey[100],
                      hintText: "Phone Number"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () => FirebaseAuthUtil().phoneAuthLogin(
                        countryCode: "91",
                        mobileNumber: _phoneController.text.toString(),
                        codeSent: (responseData) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => LoginBloc(
                                          loginRepository:
                                              LoginRepositoryImpl(),
                                        ),
                                        child: OtpScreen(
                                            firebaseData: responseData),
                                      )));
                        },
                        verificationFailed: (e) => loginBloc!.add(
                            FirebaseVerificationFailedEvent(
                                message: e.message.toString(),
                                isResendOtp: true))),
                    child: const Text('Get OTP')),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, LoginStates state) {
          if (state is LoginSendOtpLoadingState) {
            // print('LoginSendOtpLoadedState');
          }

          if (state is LoginSendOtpLoadedState) {
            // print('LoginSendOtpLoadedState');
          }

          if (state is LoginSendOtpErrorState) {
            // print('LoginSendOtpErrorState');
          }
        },
      ),
    );
  }
}
