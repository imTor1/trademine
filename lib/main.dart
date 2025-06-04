import 'package:flutter/material.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
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
      home: Stack(children: [NavigationBarPage()]),
    );
  }

}

