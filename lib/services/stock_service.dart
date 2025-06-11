import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceStock {
  static final Uri _TopStock = Uri.parse(ApiConstants.topStock);

  Future<Map<String,dynamic>>TopStock()async{
    final response = await http.get(_TopStock);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unknown error');
    }
  }
}