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
  scaffoldBackgroundColor: const Color(
    0xFFF5F7FA,
  ), // สีพื้นสบายตา ฟ้าอ่อน very light gray-blue
  cardColor: Colors.white,
  primaryColor: const Color(0xFF0A3D62), // สีน้ำเงินเข้ม
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0A3D62), // เน้นน้ำเงินเข้ม
    secondary: Color(0xFF27AE60), // สีเขียวสดใส เน้นกำไร
    error: Color(0xFFEB5757), // สีแดงสำหรับ error
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: const Color(0xFF1E272E), // สีดำอมเทาเข้ม
      fontSize: responsiveFontSize(16),
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFF485460), // สีเทาเข้ม
      fontSize: responsiveFontSize(14),
    ),
    bodySmall: TextStyle(
      color: const Color(0xFF77869E), // สีเทาอ่อน
      fontSize: responsiveFontSize(10),
    ),
    titleLarge: TextStyle(
      color: const Color(0xFF0A3D62),
      fontWeight: FontWeight.w800,
      fontSize: responsiveFontSize(28),
    ),
    titleMedium: TextStyle(
      color: const Color(0xFF0A3D62),
      fontWeight: FontWeight.w700,
      fontSize: responsiveFontSize(20),
    ),
    titleSmall: TextStyle(
      color: const Color(0xFF0A3D62),
      fontWeight: FontWeight.w600,
      fontSize: responsiveFontSize(18),
    ),
  ),

  dividerColor: const Color(0xFFE0E6ED), // สีเทา very light divider
  iconTheme: const IconThemeData(color: Color(0xFF0A3D62)),
);
