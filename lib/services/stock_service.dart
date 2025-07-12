import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
import 'package:trademine/page/widget/recomment_stock.dart';
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceStock {
  static final Uri _TopStock = Uri.parse(ApiConstants.topStock);
  static final Uri _StockDetail = Uri.parse(ApiConstants.stock_detail);

  static Future<List<dynamic>> RecommentStock() async {
    final response = await http.get(_TopStock);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['topStocks'];
    } else {
      throw (data['error'] ?? 'Unknown error');
    }
  }

  static Future<Map<String, dynamic>> StockDetail(
    String stockSymbol, {
    required String timeframe,
  }) async {
    final url = Uri.parse('$_StockDetail$stockSymbol?timeframe=$timeframe');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Invalid JSON format');
      }
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to load stock detail');
    }
  }
}
