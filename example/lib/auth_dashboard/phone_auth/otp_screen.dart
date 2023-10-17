import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_event.dart';
import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatefulWidget {
  final Map firebaseData;
  const OtpScreen({Key? key, required this.firebaseData}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();
    // initSmsListener();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP screen')),
      body: BlocConsumer<LoginBloc, LoginStates>(
          listener: (BuildContext context, LoginStates state) async {
        if (state is VerifyOtpLoadingState) {
          // print('VerifyOtpLoadingState');
        }
        if (state is VerifyOtpLoadedState) {
          // print('VerifyOtpLoadedState');
        }
        if (state is VerifyOtpErrorState) {
          // print('Invalid OTP');
        }
      }, builder: (BuildContext context, LoginStates state) {
        return Column(
          children: [
            // Verify OTP
            TextFormField(
              controller: _otpController,
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
              inputFormatters: [
                FilteringTextInputFormatter(RegExp("[0-9/]"), allow: true),
                LengthLimitingTextInputFormatter(6)
              ],
              maxLength: 10,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  filled: true,
                  counter: const Text(''),
                  fillColor: Colors.grey[100],
                  hintText: "Verify OTP"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  loginBloc!.add(LoginVerifyOtpEvent(requestData: {
                    "mobileNo": widget.firebaseData['mobileNo'],
                    "otp": _otpController.text.toString(),
                    "verificationId": widget.firebaseData['verificationId'],
                    "resendToken": widget.firebaseData['resendToken']
                  }));
                },
                child: const Text('Verify OTP'))
          ],
        );
      }),
    );
  }
}
