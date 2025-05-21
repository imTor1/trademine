import 'package:flutter/material.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/sigup_page/signup_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeMine',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Stack(children: [LoginPage()]),
    );
  }

}

class ColorApp{
  final Color _primaryColor = const Color(0xffFCA311);
  final Color _blueColor = const Color(0xff2D9CDB);
  final Color _errorColor = const Color(0xffEB5757);
  final Color _backgroundColor = const Color(0xffE5E5E5);
}

