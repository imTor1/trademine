import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceUser {
  static final Uri _Profile = Uri.parse(ApiConstants.profile);
  static final Uri _StockFavorite = Uri.parse(ApiConstants.stock_favorite);

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
      Uri.parse('$_StockFavorite'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<void> followStock(String token, String stockSymbol) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/favorites');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'stock_symbol': stockSymbol}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      throw (data['error'] ?? 'Unknown error');
    }
  }

  static Future<void> unfollowStock(String token, String stockSymbol) async {
    final url = Uri.parse(ApiConstants.stock_favorite);

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'stock_symbol': stockSymbol}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unfollow failed');
    }
  }
}
