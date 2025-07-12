import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/notification/noti_test.dart';
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_email.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_otp.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_password.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/navigation/profile_page.dart';
import 'package:trademine/page/search/search.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/sigup_page/signup_otp.dart';
import 'package:trademine/page/sigup_page/signup_password.dart';
import 'package:trademine/page/sigup_page/signup_profile.dart';
import 'package:trademine/page/splash/splash_screen.dart';
import 'package:trademine/theme/app_styles.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (_) => UserCubit()..loadUser())],
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
      home: Stack(children: [NavigationBarPage()]),
    );
  }
}
