import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';


class AuthService{
  static final Uri _LoginUrl = Uri.parse(ApiConstants.login);

  static Future<String?> Login(String email, String password) async {
    final response = await http.post(
      _LoginUrl,
      body: {'email': email, 'password': password},

    );
    final data = jsonDecode(response.body);
    if(response.statusCode == 200){
      return data['token'];
    }else{
      throw(data['error']);
    }
  }


}