import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/credit_card/HoldingStockCubit.dart';
import 'package:trademine/bloc/credit_card/TransactionCubit.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';
import 'package:trademine/bloc/notification/notificationCubit.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/splash/splash_screen.dart';
import 'package:trademine/services/notification/notification.dart';
import 'package:trademine/theme/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebaseMessaging();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()..loadUser()),
        BlocProvider(create: (_) => HomePageCubit()),
        BlocProvider(create: (_) => CreditCardCubit()),
        BlocProvider(create: (_) => HoldingStocksCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
        BlocProvider(create: (_) => TransactionCubit()),
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
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
