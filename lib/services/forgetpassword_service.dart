import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthService {
  static final Uri _ForgetPassword = Uri.parse(
    ApiConstants.forgetpassword_email,
  );
  static final Uri _OTPRegister = Uri.parse(ApiConstants.register_otp);
  static final Uri _OTPResendForgetPassword = Uri.parse(
    ApiConstants.forgetpassword_resend_otp,
  );
  static final Uri _PasswordReset = Uri.parse(
    ApiConstants.forgetpassword_reset_password,
  );

  static Future<String?> ForgetPassword(String email) async {
    final response = await http.post(_ForgetPassword, body: {'email': email});
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

  static Future<String?> OTPResendForgetPassword(String email) async {
    final response = await http.post(
      _OTPResendForgetPassword,
      body: {'email': email},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['token'];
    } else {
      throw (data['error']);
    }
  }

  static Future<String?> PasswordReset(String email, String password) async {
    final response = await http.post(
      _PasswordReset,
      body: {'email': email, 'newPassword': password},
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['token'];
    } else {
      throw (data['error']);
    }
  }
}
