import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_email.dart';
import 'package:trademine/page/loading_page/loading_circle.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/sigup_page/signup_email.dart';
import 'package:trademine/page/splash/splash_screen.dart';
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

  Future<void> _Login() async {
    if (_email.text.isEmpty && _password.text.isEmpty) {
      AppSnackbar.showError(
        context,
        "Please enter your email address and password.",
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      return;
    } else if (_email.text.isEmpty) {
      AppSnackbar.showError(
        context,
        "Please enter your email address.",
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      return;
    } else if (!_isValidEmail(_email.text)) {
      AppSnackbar.showError(
        context,
        "Please enter a valid email address.",
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      return;
    } else if (_password.text.isEmpty) {
      AppSnackbar.showError(
        context,
        "Please enter your password.",
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    CircularProgressIndicator(
      backgroundColor: Colors.blueAccent,
      color: Colors.white,
    );
    try {
      final data = await AuthService.Login(_email.text, _password.text);
      final storage = FlutterSecureStorage();

      // Validate data before storing
      if (data['token'] == null ||
          data['user'] == null ||
          data['user']['id'] == null) {
        throw Exception('Invalid response from server');
      }

      await storage.write(key: 'auth_token', value: data['token']);
      await storage.write(key: 'user_Id', value: data['user']['id'].toString());

      ScaffoldMessenger.of(context).clearSnackBars();
      _email.clear();
      _password.clear();

      setState(() {
        _isLoading = !_isLoading;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    } catch (e) {
      _password.clear();

      // Show user-friendly error message
      String errorMessage = 'Login failed. Please try again.';
      if (e.toString().contains('Invalid email or password')) {
        errorMessage =
            'Invalid email or password. Please check your credentials.';
      } else if (e.toString().contains('No internet connection')) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.toString().contains('Request timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('Server error')) {
        errorMessage = 'Server error. Please try again later.';
      }

      AppSnackbar.showError(
        context,
        errorMessage,
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/trademine_mini.png', height: 28),
            const SizedBox(width: 8),
            Text('TradeMine', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 32),
                ),
                Text(
                  'Login To Continue.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).dividerColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).hintColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _obScureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).dividerColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        color: Colors.red,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? Center(child: LoadingCircle())
                    : ElevatedButton(
                      onPressed: _isLoading ? null : _Login,
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    AppSnackbar.showError(
                      context,
                      'Login With Google Is Coming Soon.....',
                      Icons.error,
                      Theme.of(context).colorScheme.error,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blue,
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
                      Padding(padding: EdgeInsets.only(left: 10)),
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
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
