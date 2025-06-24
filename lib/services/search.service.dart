import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceSearch {
  static final Uri _SearchStock = Uri.parse(ApiConstants.search);

  static Future<Map<String, dynamic>> searchStocks(String query) async {
    final response = await http.get(Uri.parse('${_SearchStock}?query=$query'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? data['message'] ?? 'Unknown error');
    }
  }
}
