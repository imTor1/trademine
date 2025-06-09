import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_email.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_otp.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_password.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/sigup_page/signup_otp.dart';
import 'package:trademine/page/sigup_page/signup_password.dart';
import 'package:trademine/page/sigup_page/signup_profile.dart';
import 'package:trademine/theme/app_styles.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => UserCubit()..loadUser())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeMine',
      theme: lightTheme,
      darkTheme: lightTheme,
      themeMode: ThemeMode.system,
      home: Stack(children: [NavigationBarPage()]),
    );
  }
}
