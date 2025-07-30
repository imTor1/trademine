import 'dart:convert';
import 'dart:io';
import 'dart:async';
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
    try {
      final response = await http
          .post(
            _LoginUrl,
            body: {'email': email, 'password': password},
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          )
          .timeout(const Duration(seconds: 30)); // Add timeout

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Validate response structure
        if (data['token'] == null || data['user'] == null) {
          throw Exception('Invalid response format from server');
        }
        if (data['user']['id'] == null) {
          throw Exception('User ID not found in response');
        }
        return data;
      } else {
        // Handle different error types
        String errorMessage = 'Login failed';
        if (data['error'] != null) {
          errorMessage = data['error'].toString();
        } else if (response.statusCode == 401) {
          errorMessage = 'Invalid email or password';
        } else if (response.statusCode == 500) {
          errorMessage = 'Server error. Please try again later';
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          errorMessage = 'Invalid request. Please check your input';
        }
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on FormatException {
      throw Exception('Invalid response from server');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An unexpected error occurred');
    }
  }

  static Future<String?> EmailRegister(String email) async {
    final response = await http.post(_EmailRegister, body: {"email": email});
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['token'];
    } else {
      print(response.statusCode);
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
