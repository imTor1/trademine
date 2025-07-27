import 'package:flutter/material.dart';

// ลบ flutter_screenutil ออก
// double responsiveFontSize(double size, {double maxSizeFactor = 1.2}) {
//   double scaledSize = size.sp;
//   double maxSize = size * maxSizeFactor;
//   return scaledSize > maxSize ? maxSize : scaledSize;
// }

class AppColor {
  static Color primaryColor = const Color(0xffFCA311);
  // Color.from ไม่มี Constructor ที่รับ alpha, red, green, blue โดยตรง
  // อาจจะเป็น Color.fromRGBO หรือ Color.fromARGB
  // แก้ไขเป็น Color.fromARGB หรือ Color(0xAARRGGBB) ถ้าต้องการระบุ alpha
  static Color primaryColor2 = const Color.fromARGB(
    255, // Alpha (255 = fully opaque)
    255, // Red
    206, // Green (0.808 * 255 = 206)
    71, // Blue (0.278 * 255 = 71)
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
  fontFamily:
  'Roboto', // หรือเลือกฟอนต์ที่อ่านง่ายและโมเดิร์น เช่น Open Sans, Lato
  scaffoldBackgroundColor: const Color(
    0xFFF9FAFB,
  ), // สีขาวอมเทาอ่อนมาก คลีนสุดๆ
  cardColor: Colors.white, // ขาวสะอาด สำหรับ Card และพื้นผิวหลัก

  primaryColor: const Color(
    0xFF2C5282,
  ), // น้ำเงินหม่น (Slate Blue) ดูสุขุม มั่นคง
  // ใช้ ColorScheme เพื่อกำหนดบทบาทของสีให้ชัดเจนขึ้น
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2C5282), // น้ำเงินหม่น เป็นสีหลักที่น่าเชื่อถือ
    onPrimary: Colors.white, // ข้อความบนสี Primary
    secondary: Color(
      0xff27AE60,
    ), // เขียวเข้ม (Deep Forest Green) แสดงถึงการเติบโต
    onSecondary: Colors.white, // ข้อความบนสี Secondary
    tertiary: Color(
      0xFFA5B4FC,
    ), // ม่วงอ่อนพาสเทล (Lavender Blue) สำหรับเน้นเล็กน้อย
    onTertiary: Color(0xFF2C5282), // ข้อความบนสี Tertiary
    error: Color(0xFFD9534F), // แดงอมส้ม (Crimson Red) สำหรับข้อผิดพลาด
    onError: Colors.white, // ข้อความบนสี Error
    surface:
    Colors.white, // สีพื้นผิวของ Material components (เช่น Card, Dialog)
    onSurface: Color(0xFF1F2937), // สีข้อความบนพื้นผิว
    background: Color(0xFFF9FAFB), // สีพื้นหลังโดยรวม
    onBackground: Color(0xFF1F2937), // สีข้อความบนพื้นหลัง
  ),

  dividerColor: const Color(0xFFE5E7EB), // สีเส้นแบ่งที่บางเบา ไม่รบกวนสายตา
  iconTheme: const IconThemeData(
    color: Color(0xFF4B5563),
  ), // ไอคอนสีเทาเข้ม ดูเรียบง่าย

  textTheme: const TextTheme( // เปลี่ยนเป็น const TextTheme
    displayLarge: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 57, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 45, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 36, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 32, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 28, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 24, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 22, // เปลี่ยน
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 18, // เปลี่ยน
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 16, // เปลี่ยน
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF374151),
      fontSize: 16, // เปลี่ยน
    ), // ข้อความเนื้อหาหลัก
    bodyMedium: TextStyle(
      color: Color(0xFF4B5563),
      fontSize: 14, // เปลี่ยน
    ), // ข้อความเนื้อหารอง
    bodySmall: TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 12, // เปลี่ยน
    ), // ข้อความขนาดเล็ก/คำอธิบาย
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 14, // เปลี่ยน
      fontWeight: FontWeight.w500,
    ), // ปุ่ม
    labelMedium: TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 12, // เปลี่ยน
    ),
    labelSmall: TextStyle(
      color: Color(0xFF9CA3AF),
      fontSize: 10, // เปลี่ยน
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2C5282), // ปุ่มใช้สี primary
      foregroundColor: Colors.white, // ข้อความปุ่มสีขาว
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ), // ขอบมนกำลังดี
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ), // ขนาดปุ่มที่กดง่าย
      textStyle: const TextStyle( // เปลี่ยน
        fontSize: 16, // เปลี่ยน
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(
      0xFFF9FAFB,
    ), // พื้นหลังช่องกรอกข้อมูลสีเดียวกับ scaffold
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // เส้นขอบบางเบา
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFF2C5282),
        width: 2,
      ), // เน้นด้วยสี primary เมื่อโฟกัส
    ),
    labelStyle: const TextStyle(color: Color(0xFF6B7280)), // สีของ Label
    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // สีของ Hint
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // AppBar สีขาวสะอาด
    foregroundColor: Color(0xFF1F2937), // สีข้อความ/ไอคอนบน AppBar
    elevation: 0.5, // มีเงาบางๆ เพื่อแยกจากพื้นหลัง
    titleTextStyle: TextStyle(
      color: Color(0xFF1F2937),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF2C5282), // สี Primary เมื่อเลือก
    unselectedItemColor: const Color(0xFF6B7280), // สีเทาอ่อนเมื่อไม่เลือก
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
  ),
  // เพิ่มการตั้งค่าสำหรับ Slider (เช่นกราฟหุ้น)
  sliderTheme: SliderThemeData(
    activeTrackColor: const Color(0xFF2C5282),
    inactiveTrackColor: const Color(0xFFD1D5DB),
    thumbColor: const Color(0xFF2C5282),
    overlayColor: const Color(0x202C5282),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: const Color(
    0xFF121212,
  ), // สีเทาดำสนิท ให้ความรู้สึกสงบ
  cardColor: const Color(0xFF1E1E1E), // สีเทาดำที่เข้มกว่าเล็กน้อยสำหรับ Card
  primaryColor: const Color(
    0xFF5E8BFF,
  ), // น้ำเงินสดใส (Vibrant Blue) ตัดกับพื้นหลังเข้ม

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF5E8BFF), // น้ำเงินสดใส
    secondary: Color(0xFF00C853), // เขียวสดใส (Emerald Green) สำหรับกราฟขึ้น
    tertiary: Color(
      0xFFBB86FC,
    ), // ม่วงอ่อน (Light Amethyst) สำหรับเน้นหรือกราฟบางส่วน
    error: Color(0xFFCF6679), // แดงอมม่วง (Rose Red) สำหรับสถานะที่ไม่ดี
    onPrimary: Colors.black, // ข้อความบน primary color
    onSecondary: Colors.black, // ข้อความบน secondary color
    onTertiary: Colors.black, // ข้อความบน tertiary color
    onError: Colors.black, // ข้อความบน error color
    surface: Color(0xFF1E1E1E), // สีพื้นผิวสำหรับ Material Components
    onSurface: Colors.white, // สีข้อความบนพื้นผิว
    background: Color(0xFF121212),
    onBackground: Colors.white,
  ),

  dividerColor: const Color(0xFF333333), // สีเส้นแบ่งที่ชัดเจนแต่ไม่รบกวน
  iconTheme: const IconThemeData(color: Colors.white70), // ไอคอนสีขาวที่นุ่มนวล

  textTheme: const TextTheme( // เปลี่ยนเป็น const TextTheme
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 57, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 45, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 36, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 32, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 28, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 24, // เปลี่ยน
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 22, // เปลี่ยน
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 18, // เปลี่ยน
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 16, // เปลี่ยน
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: Colors.white70,
      fontSize: 16, // เปลี่ยน
    ), // ข้อความหลัก
    bodyMedium: TextStyle(
      color: Colors.white70,
      fontSize: 14, // เปลี่ยน
    ),
    bodySmall: TextStyle(
      color: Colors.white54,
      fontSize: 12, // เปลี่ยน
    ), // ข้อความรอง
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 14, // เปลี่ยน
      fontWeight: FontWeight.w500,
    ), // ปุ่ม
    labelMedium: TextStyle(
      color: Colors.white70,
      fontSize: 12, // เปลี่ยน
    ),
    labelSmall: TextStyle(
      color: Colors.white54,
      fontSize: 10, // เปลี่ยน
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5E8BFF), // ปุ่มใช้สี primary
      foregroundColor: Colors.black, // ข้อความปุ่มสีดำ
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle( // เปลี่ยน
        fontSize: 16, // เปลี่ยน
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C), // พื้นหลังช่องกรอกข้อมูล
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, // ไม่มีเส้นขอบ
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xFF5E8BFF),
        width: 2,
      ), // เน้นด้วยสี primary เมื่อโฟกัส
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white38),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E), // AppBar สีเข้มกว่าพื้นหลังเล็กน้อย
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    selectedItemColor: const Color(0xFF5E8BFF),
    unselectedItemColor: Colors.white54,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
  ),
);