import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
  cardColor: Colors.white,
  primaryColor: const Color(0xFF2C5282),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2C5282),
    onPrimary: Colors.white,
    secondary: Color(0xff27AE60),
    onSecondary: Colors.white,
    tertiary: Color(0xFFA5B4FC),
    onTertiary: Color(0xFF2C5282),
    error: Color(0xFFD9534F),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF1F2937),
    background: Color(0xFFF9FAFB),
    onBackground: Color(0xFF1F2937),
  ),
  dividerColor: const Color(0xFFE5E7EB),
  iconTheme: const IconThemeData(color: Color(0xFF4B5563)),
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    titleLarge: const TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 24, // หัวข้อใหญ่
      fontWeight: FontWeight.w700,
    ),
    titleMedium: const TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 18, // หัวข้อระดับกลาง
      fontWeight: FontWeight.w600,
    ),
    titleSmall: const TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 16, // หัวข้อระดับย่อย เช่น ชื่อกล่อง
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: const TextStyle(
      color: Color(0xFF374151),
      fontSize: 16, // ข้อความเนื้อหา
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: const TextStyle(
      color: Color(0xFF4B5563),
      fontSize: 14, // ใช้ในกล่อง ข่าว หรือฟอร์ม
      fontWeight: FontWeight.w400,
    ),
    bodySmall: const TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 12, // ใช้ในรายละเอียดเล็ก เช่น วันที่ เวลา
      fontWeight: FontWeight.w400,
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF2C5282), // สี Primary เมื่อเลือก
    unselectedItemColor: const Color(0xFF6B7280), // สีเทาอ่อนเมื่อไม่เลือก
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: const Color(0xFF2C5282),
    inactiveTrackColor: const Color(0xFFD1D5DB),
    thumbColor: const Color(0xFF2C5282),
    overlayColor: const Color(0x202C5282),
  ),
);
