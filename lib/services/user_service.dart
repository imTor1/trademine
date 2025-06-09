import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceUser {
  static final Uri _Profile = Uri.parse(ApiConstants.profile);
  static final Uri _StockFavorite = Uri.parse(ApiConstants.stock_favorite_show);

  static Future<Map<String, dynamic>> ProfileFecthData(
    String userId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$_Profile/api/users/$userId/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw (data['error']);
    }
  }

  static Future<List<dynamic>> ShowFavoriteStock(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.stock_favorite_show}/api/favorites'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unknown error');
    }
  }
}
