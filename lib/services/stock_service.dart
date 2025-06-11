import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceStock {
  static final Uri _TopStock = Uri.parse(ApiConstants.topStock);

  static Future<List<dynamic>>TopStock()async{
    final response = await http.get(_TopStock);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['topStocks'];
    } else {
      throw (data['error'] ?? 'Unknown error');
    }
  }
}