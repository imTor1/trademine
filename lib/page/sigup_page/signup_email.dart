import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/sigup_page/signup_otp.dart';
import 'package:trademine/page/loading_page/loading_screen.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/services/auth_service.dart';
import 'package:flutter/gestures.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _email = TextEditingController();
  bool isChecked = false;
  bool _isLoading = false;
  bool isPolicyAgree = false;

  void PolicyAgree() {
    setState(() {
      isPolicyAgree = !isPolicyAgree;
      Navigator.pop(context);
      isChecked = true;
    });
  }

  Future<void> ApiConnect() async {
    try {
      LoadingScreen.show(context);
      setState(() {
        _isLoading = true;
      });
      final storage = FlutterSecureStorage();
      await storage.write(key: 'email', value: _email.text);
      await AuthService.EmailRegister(_email.text);
      LoadingScreen.hide(context);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SignUpOtp(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                  'Sign Up For An Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                Text(
                  'Enter your email to receive an OTP.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    filled: true,
                    fillColor: Theme.of(context).dividerColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        if (_email.text != '') {
                          setState(() {
                            isChecked = newValue!;
                          });
                        } else {
                          AppSnackbar.showError(context, 'Enter You Email');
                        }
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.primary,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed:
                      isChecked
                          ? () {
                            ApiConnect();
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
