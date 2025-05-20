import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:trademine/bloc/loading_cubit.dart' show LoadingCubit;

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, bool>(
      builder: (context, isLoading) {
        print(isLoading);
        if (!isLoading) return SizedBox.shrink();

        return Container(
          color: Colors.white,
          child: Center(
            child: Lottie.asset(
              'assets/lottie/loading_screen2.json',
              width: 200,
              height: 200,
            ),
          ),
        );
      },
    );
  }
}
