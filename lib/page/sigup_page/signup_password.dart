import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/sigup_page/signup_profile.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({super.key});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password_confirm = TextEditingController();
  final url = Uri.parse('http://localhost:3000/api/register/set-password');
  var _obScureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obScureText = !_obScureText;
    });
  }

  Future<void> ApiConnect() async {
    try {
      final storage = FlutterSecureStorage();
      String? email = await storage.read(key: 'email');
      final response = await http.post(
        url,
        body: {'email': email.toString(), 'password': _password.text},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await storage.write(key: 'token-register', value: token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpProfile()),
        );
      } else {
        print('connect error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR: $e', style: TextStyle(color: Colors.red)),
        ),
      );
    }
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
                        Navigator.pop(context, 'Hide');
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Set Your Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto', // ตั้งชื่อฟอนต์
                    letterSpacing: -1, // ระยะห่างระหว่างตัวอักษร
                  ),
                ),

                Text(
                  'Choose a strong password for your account.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _password_confirm,
                  obscureText: _obScureText,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Color(0xffE5E5E5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _togglePasswordVisibility();
                      },
                      icon: Icon(
                        _obScureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),

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

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_password.text == _password_confirm.text) {
                      ApiConnect();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password dont Match')),
                      );
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xffFCA311),
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
