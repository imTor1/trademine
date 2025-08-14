import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static Flushbar<dynamic>? _current;

  static void showError(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    _show(
      context,
      message,
      icon: icon,
      iconColor: color,
      duration: const Duration(seconds: 1),
      position: FlushbarPosition.BOTTOM,
    );
  }

  // New helpers with sensible defaults
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 1),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    _show(
      context,
      message,
      icon: Icons.check_circle,
      iconColor: Theme.of(context).colorScheme.secondary,
      duration: duration,
      position: position,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 1),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    _show(
      context,
      message,
      icon: Icons.info,
      iconColor: Theme.of(context).colorScheme.primary,
      duration: duration,
      position: position,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 1),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    _show(
      context,
      message,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orangeAccent,
      duration: duration,
      position: position,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color iconColor,
    Duration duration = const Duration(seconds: 2),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Colors.grey.shade900 : Colors.black87;

    _current?.dismiss();

    final bar = Flushbar(
      message: message,
      icon: Icon(icon, color: iconColor),
      duration: duration,
      backgroundColor: bg,
      flushbarPosition: position,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.all(14),
      animationDuration: const Duration(milliseconds: 200),
    );
    _current = bar;
    bar.show(context).then((_) {
      if (identical(_current, bar)) {
        _current = null;
      }
    });
  }
}
