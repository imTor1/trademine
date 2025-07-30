import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/sigup_page/signup_otp.dart';
import 'package:trademine/page/splash/splash_screen.dart';
import 'package:trademine/services/notification/notification.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebaseMessaging();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()..loadUser()),
        BlocProvider(create: (_) => HomePageCubit()),
        BlocProvider(create: (_) => CreditCardCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeMine',
      theme: lightTheme,
      darkTheme: lightTheme,
      themeMode: ThemeMode.system,
      home: Stack(children: [SplashScreen()]),
    );
  }
}
