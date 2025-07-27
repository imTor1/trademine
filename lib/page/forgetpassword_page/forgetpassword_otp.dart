import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

      final storage = FlutterSecureStorage();
      String? _email = await storage.read(key: 'email');
      final fullotp = otp.toString();
      final token = await AuthService.OTPRegister(_email.toString(), fullotp);
      await storage.write(key: 'regis_token', value: token);

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

  @override
  void dispose() {
    for (var controller in _otp) {
      controller.dispose();
    }
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
                _isLoading
                    ? Center(child: LoadingCircle())
                    : ElevatedButton(
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
                                    Icons.error,
                                    Theme.of(context).colorScheme.error,
                                  );
                                } else {
                                  ApiConnect(getOtpCode());
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
