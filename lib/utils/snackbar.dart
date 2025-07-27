import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:trademine/theme/app_styles.dart';

class AppSnackbar {
  static void showError(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    Flushbar(
      message: message,
      icon: Icon(icon, color: color),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black87,
      flushbarPosition: FlushbarPosition.TOP, // หรือ .BOTTOM
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(16),
    ).show(context);
  }
}
