import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/sigup_page/signup_password.dart';
import 'package:trademine/services/auth_service.dart';
import 'package:trademine/page/loading_page/loading_screen.dart';
import 'package:trademine/utils/snackbar.dart';

class SignUpOtp extends StatefulWidget {
  const SignUpOtp({super.key});

  @override
  State<SignUpOtp> createState() => SignupOtpState();
}

class SignupOtpState extends State<SignUpOtp> {
  final List<TextEditingController> _otp = List.generate(
    6,
    (index) => TextEditingController(),
  );
  bool isChecked = false;
  bool _isLoading = false;

  String getOtpCode() {
    return _otp.map((c) => c.text).join();
  }

  Future<void> ApiConnect(String otp) async {
    try {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();
      LoadingScreen.show(context);

      final storage = FlutterSecureStorage();
      String? _email = await storage.read(key: 'email');
      final fullotp = otp.toString();
      final token = await AuthService.OTPRegister(_email.toString(), fullotp);
      await storage.write(key: 'regis_token', value: token);

      LoadingScreen.hide(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPassword()),
      );
    } catch (e) {
      FocusScope.of(context).unfocus();
      LoadingScreen.hide(context);
      AppSnackbar.showError(context, e.toString());

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otp) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter Your OTP',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                Text(
                  'Enter the OTP sent your email.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                            bool allFilled = _otp.every(
                              (controller) => controller.text.length == 1,
                            );
                            setState(() {
                              isChecked = allFilled;
                            });
                          },
                          autofocus: index == 0,
                          controller: _otp[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            fillColor: Color(0xffE5E5E5),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 30.0,
                            ),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Resent OTP\t',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : isChecked
                          ? () {
                            String fullOTP = getOtpCode();
                            if (fullOTP.length != 6) {
                              AppSnackbar.showError(
                                context,
                                'Please enter the complete OTP in all fields.',
                              );
                            } else {
                              ApiConnect(getOtpCode());
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
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
