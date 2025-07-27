import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/splash/splash_screen.dart';
import 'package:trademine/theme/app_styles.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UserCubit()..loadUser()),
            BlocProvider(create: (_) => HomePageCubit()),
            BlocProvider(create: (_) => CreditCardCubit()),
          ],
          child: MyApp(),
        );
      },
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
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Stack(children: [SplashScreen()]),
    );
  }
}
