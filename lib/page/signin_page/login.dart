import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trademine/page/loading_page/loading.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/sigup_page/signup_email.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final url = Uri.parse('http://localhost:3000/api/login');
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var _obScureText = true;
  bool _isLoading = false;
  bool gmailAccount = false;

  final Color _primaryColor = const Color(0xffFCA311);
  final Color _accentColor = const Color(0xff2D9CDB);
  final Color _errorColor = const Color(0xffEB5757);
  final Color _backgroundColor = const Color(0xffE5E5E5);

  void _togglePasswordVisibility() {
    setState(() {
      _obScureText = !_obScureText;
    });
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> ApiConnect() async {
    if (_email.text.isEmpty) {
      _showErrorSnackBar('Email is Empty');
      return;
    }

    if (!_isValidEmail(_email.text)) {
      _showErrorSnackBar('Email Type is not Correct');
      return;
    }

    if (_password.text.isEmpty) {
      _showErrorSnackBar('Password is Empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: LottieLoading(),
        );
      },
    );

    try {
      final response = await http.post(
        url,
        body: {'email': _email.text, 'password': _password.text},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final storage = FlutterSecureStorage();
        await storage.write(key: 'auth_token', value: token);
        _email.clear();
        _password.clear();

        Navigator.pop(context);
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationBarPage()),
        );
      } else {
        Navigator.pop(context);
        _showErrorSnackBar('Fail to Connect Server : ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorSnackBar('Fail to Connect Server | Check You Internet');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/trademine_mini.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'TradeMine',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Login To Continue.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: _backgroundColor,
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _password,
                  obscureText: _obScureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _obScureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    filled: true,
                    fillColor: _backgroundColor,
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: _errorColor,
                        color: _errorColor,
                        letterSpacing: 0,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : ApiConnect,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: _primaryColor,
                  ),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: _accentColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/login_with_google.png',
                          width: 30,
                          height: 30,
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(left: 15)),
                      Text(
                        'CONTINUE WITH GOOGLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Create an account'),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignUpEmail(),
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
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: _errorColor,
                          decoration: TextDecoration.underline,
                          decorationColor: _errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
