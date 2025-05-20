import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/loading_cubit.dart';
import 'package:trademine/bloc/loading_page.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/sigup_page/signup_email.dart';

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
      home: Stack(children: [LoginApp()]),
    );
  }
}
