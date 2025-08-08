import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:trademine/page/setting/edit_profile.dart';
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceUser {
  static final Uri _Profile = Uri.parse(ApiConstants.profile);
  static final Uri _StockFavorite = Uri.parse(ApiConstants.stock_favorite);
  static final Uri _EditProfile = Uri.parse(ApiConstants.edit_profile);

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

  static Future<void> editProfile(
    String token,
    String userId,
    String username,
    DateTime birthday,
    String gender,
    File? imageFile,
  ) async {
    final url = Uri.parse('$_EditProfile/api/users/$userId/profile');

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['username'] = username;
    request.fields['birthday'] = DateFormat('yyyy-MM-dd').format(birthday);
    request.fields['gender'] = gender;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profileImage', imageFile.path),
      );
    }
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final data = jsonDecode(respStr);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to update profile');
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
