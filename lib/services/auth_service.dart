import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  static final Uri _LoginUrl = Uri.parse(ApiConstants.login);
  static final Uri _EmailRegister = Uri.parse(ApiConstants.register_email);
  static final Uri _OTPRegister = Uri.parse(ApiConstants.register_otp);
  static final Uri _PasswordRegister = Uri.parse(
    ApiConstants.register_password,
  );
  static final Uri _ProfileRegister = Uri.parse(ApiConstants.register_profile);

  static Future<Map<String, dynamic>> Login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      _LoginUrl,
      body: {'email': email, 'password': password},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw (data['error']);
    }
  }

  static Future<String?> EmailRegister(String email) async {
    final response = await http.post(_EmailRegister, body: {"email": email});
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['token'];
    } else {
      throw (data['error']);
    }
  }

  static Future<String?> OTPRegister(String email, String otp) async {
    final response = await http.post(
      _OTPRegister,
      body: {'email': email, "otp": otp},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['token'];
    } else {
      throw (data['error']);
    }
  }

  static Future<String?> PasswordRegister(String email, String password) async {
    final response = await http.post(
      _PasswordRegister,
      body: {'email': email, 'password': password},
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['token'];
    } else {
      throw (data['error']);
    }
  }

  static Future<String?> ProfileRegister(
    String token,
    String username,
    DateTime birthday,
    String gender,
    File imageFile,
  ) async {
    final request =
        http.MultipartRequest('POST', _ProfileRegister)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['newUsername'] = username
          ..fields['birthday'] = DateFormat('dd/MM/yyyy').format(birthday)
          ..fields['gender'] = gender
          ..files.add(
            await http.MultipartFile.fromPath('picture', imageFile.path),
          );

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);

    if (response.statusCode == 200) {
      return data['token'];
    } else {
      throw (data['error']);
    }
  }
}
