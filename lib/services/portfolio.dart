import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/page/widget/holdingStocks.dart';
import 'package:trademine/services/constants/api_constants.dart';

class AuthServicePortfolio {
  static final Uri _CreditDemo = Uri.parse(ApiConstants.creditDemo);
  static final Uri _Portfolio = Uri.parse(ApiConstants.portfolio);
  static final Uri _Transaction = Uri.parse(ApiConstants.transaction_history);

  static Future<Map<String, dynamic>> Portfolio(String token) async {
    final response = await http
        .get(
          _Portfolio,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Invalid JSON format');
      }
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('HTTP ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> CreditDemo(
    String token,
    String amount,
  ) async {
    final response = await http
        .post(
          _CreditDemo,
          body: {'amount': amount},
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Invalid format');
      }
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<Map<String, dynamic>> TransactionHistory(String token) async {
    final response = await http
        .get(
          _Transaction,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Invalid format');
      }
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}
