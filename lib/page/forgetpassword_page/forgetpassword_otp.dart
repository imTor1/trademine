import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_password.dart';
import 'package:trademine/page/loading_page/loading_circle.dart';
import 'package:trademine/services/forgetpassword_service.dart';
import 'package:trademine/utils/snackbar.dart';

class ForgetpasswordOtp extends StatefulWidget {
  const ForgetpasswordOtp({super.key});

  @override
  State<ForgetpasswordOtp> createState() => _ForgetpasswordOtpState();
}

class _ForgetpasswordOtpState extends State<ForgetpasswordOtp> {
  final TextEditingController _otpController = TextEditingController();
  int _resendCountdown = 0;
  Timer? _timer;
  bool isChecked = false;
  bool _isLoading = false;

  Future<void> SendOTP(String otp) async {
    try {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();

      final storage = FlutterSecureStorage();
      String? _email = await storage.read(key: 'email');
      final fullotp = otp.toString();
      final token = await AuthService.OTPRegister(_email.toString(), fullotp);
      await storage.write(key: 'regis_token', value: token);
      setState(() {
        _isLoading = !_isLoading;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgetpasswordPassword()),
      );
    } catch (e) {
      FocusScope.of(context).unfocus();
      AppSnackbar.showError(
        context,
        e.toString(),
        Icons.error,
        Theme.of(context).colorScheme.error,
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  void startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _resendCountdown--;
        if (_resendCountdown == 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> ResendOtp(String otp) async {
    startResendCountdown();
    try {
      final storage = FlutterSecureStorage();
      String? _email = await storage.read(key: 'email');
      final fullotp = otp.toString();
      final token = await AuthService.OTPResendForgetPassword(
        _email.toString(),
      );
    } catch (e) {
      FocusScope.of(context).unfocus();
      AppSnackbar.showError(
        context,
        e.toString(),
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Your OTP',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                Text(
                  'Enter the OTP sent your email.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(height: 30),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value.length == 6;
                      });
                    },
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 80,
                      textStyle: Theme.of(context).textTheme.titleLarge,
                      decoration: BoxDecoration(
                        color: const Color(0xffE5E5E5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap:
                            (_resendCountdown > 0)
                                ? null
                                : () {
                                  ResendOtp(_otpController.text);
                                },
                        child: Text(
                          _resendCountdown > 0
                              ? 'Resend OTP ($_resendCountdown)'
                              : 'Resend OTP',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(
                            color:
                                (_resendCountdown > 0)
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _isLoading
                    ? Center(child: LoadingCircle())
                    : ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : isChecked
                              ? () {
                                if (_otpController.length != 6) {
                                  AppSnackbar.showError(
                                    context,
                                    'Please enter the complete OTP in all fields.',
                                    Icons.error,
                                    Theme.of(context).colorScheme.error,
                                  );
                                } else {
                                  SendOTP(_otpController.text);
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'SEND OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
