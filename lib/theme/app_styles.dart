import 'package:flutter/material.dart';

class AppColor {
  static Color primaryColor = const Color(0xffFCA311);
  static Color primaryColor2 = const Color.from(
    alpha: 1,
    red: 1,
    green: 0.808,
    blue: 0.278,
  );
  static Color blueColor = const Color(0xff2D9CDB);
  static Color errorColor = const Color(0xffEB5757);
  static Color greenColor = const Color(0xff27AE60);
  static Color backgroundColor = const Color(0xffE5E5E5);
  static Color textColor = const Color(0xff14213D);
  static Color textColor2 = const Color(0xff606060);
  static Color divider = const Color(0xffE5E5E5);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
  primaryColor: Color(0xffFFCE47),

  //login Page color
  colorScheme: ColorScheme.light(
    primary: Color(0xffFCA311),
    secondary: Color(0xff2D9CDB),
    error: Color(0xffEB5757),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: const Color(0xff14213D), fontSize: 16),
    bodyMedium: TextStyle(color: const Color(0xff14213D), fontSize: 14),
    bodySmall: TextStyle(color: const Color(0xff14213D), fontSize: 12),

    titleLarge: TextStyle(
      color: const Color(0xff14213D),
      fontWeight: FontWeight.w800,
      fontSize: 32,
    ),
    titleMedium: TextStyle(
      color: const Color(0xff14213D),
      fontWeight: FontWeight.w800,
      fontSize: 22,
    ),
    titleSmall: TextStyle(
      color: const Color(0xff14213D),
      fontWeight: FontWeight.w800,
      fontSize: 18,
    ),
  ),
  dividerColor: Color(0xffE5E5E5),
  iconTheme: IconThemeData(color: Color(0xff14213D)),
);
