import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_otp.dart';
import 'package:trademine/page/sigup_page/signup_otp.dart';
import 'package:trademine/page/loading_page/loading_screen.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/services/forgetpassword_service.dart';
import 'package:email_validator/email_validator.dart';




class ForgetpasswordEmail extends StatefulWidget {
  const ForgetpasswordEmail({super.key});

  @override
  State<ForgetpasswordEmail> createState() => _ForgetpasswordEmailState();
}

class _ForgetpasswordEmailState extends State<ForgetpasswordEmail> {
  final TextEditingController _email = TextEditingController();
  bool _isLoading =false;
  bool _isValidEmail(String email) => EmailValidator.validate(email);


  Future<void> ApiConnect() async {
    if (!_isValidEmail(_email.text)) {
      AppSnackbar.showError(context, "Please enter a valid email address.");
    }

    setState(() {
      _isLoading = true;
    });

    LoadingScreen.show(context);
    FocusScope.of(context).unfocus();
    try {
      final storage = FlutterSecureStorage();
      await storage.write(key: 'email', value: _email.text);
      await AuthService.ForgetPassword(_email.text);
      LoadingScreen.hide(context);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => ForgetpasswordOtp(),
          transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
              ) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      LoadingScreen.hide(context);
      AppSnackbar.showError(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'Forgot Your Password?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: -1,
                  ),
                ),

                Text(
                  'Enter your email to receive an OTP.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Color(0xffE5E5E5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),


                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed:_isLoading ? null :
                () {
                    ApiConnect();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xffFCA311),
                  ),
                  child: Text(
                    'GET OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
