import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_email.dart';
import 'package:trademine/page/loading_page/loading_screen.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/sigup_page/signup_email.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:trademine/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var _obScureText = true;
  bool _isLoading = false;
  bool gmailAccount = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obScureText = !_obScureText;
    });
  }

  bool _isValidEmail(String email) => EmailValidator.validate(email);

  Future<void> ApiConnect() async {
    if (_email.text.isEmpty && _password.text.isEmpty) {
      AppSnackbar.showError(
        context,
        "Please enter your email address and password.",
      );
    } else if (_email.text.isEmpty) {
      AppSnackbar.showError(context, "Please enter your email address.");
    } else if (!_isValidEmail(_email.text)) {
      AppSnackbar.showError(context, "Please enter a valid email address.");
    } else if (_password.text.isEmpty) {
      AppSnackbar.showError(context, "Please enter your password.");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    LoadingScreen.show(context);
    FocusScope.of(context).unfocus();
    try {
      final data = await AuthService.Login(_email.text, _password.text);
      final storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: data['token']);
      await storage.write(key: 'user_Id', value: data['user']['id'].toString());
      print(data['token']);
      context.read<UserCubit>().setUser(
        data['user']['username'],
        data['user']['email'],
      );

      ScaffoldMessenger.of(context).clearSnackBars();
      LoadingScreen.hide(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavigationBarPage()),
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Login To Continue.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
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
                TextFormField(
                  controller: _password,
                  obscureText: _obScureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _obScureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetpasswordEmail(),
                        ),
                      );
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.errorColor,
                        color: AppColor.errorColor,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    AppSnackbar.showError(
                      context,
                      'Login With Google Is Coming Soon.....',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
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
                    Text(
                      'Create an account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        _email.clear();
                        _password.clear();
                        ScaffoldMessenger.of(context).clearSnackBars();
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
                          color: AppColor.errorColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.errorColor,
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
