import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/widget/loop_typing_animation.dart';
import 'package:trademine/services/constants/api_constants.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/utils/snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadingData();
    Future.microtask(() {
      context.read<HomePageCubit>().fetchData();
      context.read<CreditCardCubit>().fetchCards();
    });
  }

  Future<void> _loadingData() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      if (!mounted) return;
      if (token != null && token.isNotEmpty) {
        final String? userId = await storage.read(key: 'user_Id');
        //final favoriteStock = await AuthServiceUser.ShowFavoriteStock(token);
        final profile = await AuthServiceUser.ProfileFecthData(userId!, token);
        final image = ApiConstants.baseUrl + profile['profileImage'];

        if (!mounted) return;
        context.read<UserCubit>().setUser(
          profile['username'].toString(),
          profile['email'].toString(),
          profile['gender'].toString(),
          profile['birthday'].toString(),
          profile['age'].toString(),
          image.toString(),
        );
        await Future.delayed(const Duration(milliseconds: 1300));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationBarPage()),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        '$e',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypingTextAnimation(
              text: 'Trademine'.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
              typingDuration: const Duration(milliseconds: 150),
              pauseDuration: const Duration(milliseconds: 500),
              loop: true,
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white70,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  minHeight: 6,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
