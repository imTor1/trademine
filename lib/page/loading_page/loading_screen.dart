import 'package:flutter/material.dart';
import 'package:trademine/page/loading_page/loading.dart';

class LoadingScreen {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: LottieLoading(),
        );
      },
    );
  }
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

}
