import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceUser {
  static final Uri _LatestNews = Uri.parse(ApiConstants.stock_favorite_show);

  static Future<Map<String, dynamic>>LatestNews() async {
    final response = await http.get(_LatestNews);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unknown error');
    }
  }
}