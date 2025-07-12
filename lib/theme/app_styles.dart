import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double responsiveFontSize(double size, {double maxSizeFactor = 1.2}) {
  double scaledSize = size.sp;
  double maxSize = size * maxSizeFactor;
  return scaledSize > maxSize ? maxSize : scaledSize;
}

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
  scaffoldBackgroundColor: const Color(0xFFF5F7FA), // เทาอ่อนสว่างมาก
  cardColor: Colors.white,
  primaryColor: const Color(0xFF0A2540), // น้ำเงินกรมเข้ม

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0A2540),
    secondary: Color(0xFF00B386), // เขียวเข้มโทนมืออาชีพขึ้น
    error: Color(0xFFE53935), // แดงเข้ม ชัดกว่า EB5757
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),

  dividerColor: const Color(0xFFE0E0E0),
  iconTheme: const IconThemeData(color: Color(0xFF0A2540)),

  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: const Color(0xFF2C3E50),
      fontSize: responsiveFontSize(16),
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFF455A64),
      fontSize: responsiveFontSize(14),
    ),
    bodySmall: TextStyle(
      color: const Color(0xFF78909C), // เข้มขึ้นเล็กน้อย อ่านง่ายขึ้น
      fontSize: responsiveFontSize(12),
    ),
    titleLarge: TextStyle(
      color: const Color(0xFF0A2540),
      fontWeight: FontWeight.w800,
      fontSize: responsiveFontSize(28),
    ),
    titleMedium: TextStyle(
      color: const Color(0xFF0A2540),
      fontWeight: FontWeight.w700,
      fontSize: responsiveFontSize(20),
    ),
    titleSmall: TextStyle(
      color: const Color(0xFF0A2540),
      fontWeight: FontWeight.w600,
      fontSize: responsiveFontSize(18),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0A2540),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF0A2540), width: 1.5),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: const Color(0xFF0F1A1A), // ดำอมเขียวเข้มลึกกว่า
  cardColor: const Color(0xFF1C2B2D), // ลดความสว่าง card ให้นุ่มตา
  primaryColor: const Color(0xFF00B386), // เขียวมืออาชีพ

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00B386),
    secondary: Color(0xFF26D07C),
    error: Color(0xFFFF4C4C), // แดงสดที่ยังชัดใน dark
    onPrimary: Colors.black,
    onSecondary: Colors.black,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: const Color(0xFFECEFF1), // เทาเกือบขาว อ่านง่ายขึ้น
      fontSize: responsiveFontSize(16),
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFFB0BEC5),
      fontSize: responsiveFontSize(14),
    ),
    bodySmall: TextStyle(
      color: const Color(0xFF90A4AE),
      fontSize: responsiveFontSize(12),
    ),
    titleLarge: TextStyle(
      color: const Color(0xFFECEFF1),
      fontWeight: FontWeight.w800,
      fontSize: responsiveFontSize(28),
    ),
    titleMedium: TextStyle(
      color: const Color(0xFFECEFF1),
      fontWeight: FontWeight.w700,
      fontSize: responsiveFontSize(20),
    ),
    titleSmall: TextStyle(
      color: const Color(0xFFECEFF1),
      fontWeight: FontWeight.w600,
      fontSize: responsiveFontSize(18),
    ),
  ),

  dividerColor: const Color(0xFF263238), // divider เข้มขึ้น
  iconTheme: const IconThemeData(color: Color(0xFFB0BEC5)),
);
