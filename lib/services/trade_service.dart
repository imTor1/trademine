import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class ServiceTrade {
  static final Uri _TradeDemo = Uri.parse(ApiConstants.tradeDemo);

  static Future<String?> TradeDemo(
    String token,
    String stockSymbol,
    String quantity,
    String tradeType,
  ) async {
    final response = await http.post(
      _TradeDemo,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'stockSymbol': stockSymbol,
        'quantity': quantity,
        'tradeType': tradeType,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    } else {
      throw data['error'] ?? 'Unknown error';
    }
  }
}
