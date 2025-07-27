import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/loading_page/loading_circle.dart';
import 'package:trademine/page/sigup_page/signup_profile.dart';
import 'package:trademine/services/constants/api_constants.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/services/auth_service.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({super.key});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password_confirm = TextEditingController();
  final url = Uri.parse(ApiConstants.register_password);
  var _obScureText = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obScureText = !_obScureText;
    });
  }

  Future<void> ApiConnect() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final storage = FlutterSecureStorage();
      String? email = await storage.read(key: 'email');
      final register_token = await AuthService.PasswordRegister(
        email.toString(),
        _password_confirm.text,
      );
      await storage.write(key: 'token-register', value: register_token);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpProfile()),
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
    _password.dispose();
    _password_confirm.dispose();
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
                  'Set Your Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                Text(
                  'Choose a strong password for your account.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _password,
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
                  controller: _password_confirm,
                  obscureText: _obScureText,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
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

                const SizedBox(height: 40),
                _isLoading
                    ? Center(child: LoadingCircle())
                    : ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                if (_password.text == _password_confirm.text) {
                                  ApiConnect();
                                } else {
                                  AppSnackbar.showError(
                                    context,
                                    'Password dont Match',
                                    Icons.error,
                                    Theme.of(context).colorScheme.error,
                                  );
                                }
                              },
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
                        'SAVE',
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
