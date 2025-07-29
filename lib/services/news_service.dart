import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trademine/services/constants/api_constants.dart';

class AuthServiceNews {
  static final Uri _NewsDetail = Uri.parse(ApiConstants.news_detail);
  static final Uri _NewsRecommentStockDetailPage = Uri.parse(ApiConstants.recomment_newStockDetailPage);

  static Future<Map<String, dynamic>> LatestNews({
    int limit = 20,
    int offset = 0,
    String source = 'All',
    String sortOptions = '',
    String selectedSentiment = '',
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.latest_news}?'
      'limit=$limit&'
      'offset=$offset&'
      'source=${Uri.encodeComponent(source)}&'
      'sort=${Uri.encodeComponent(sortOptions)}&'
      'sentiment=${Uri.encodeComponent(selectedSentiment)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unknown error');
    }
  }

  static Future<Map<String, dynamic>> getNewsDetail(int newID) async {
    final url = Uri.parse('$_NewsDetail?id=$newID');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unknown error');
    }
  }

  static Future<List<Map<String, dynamic>>> getNewsRecommentStockDetailPage(String stockSymbol) async {
    final url = Uri.parse('$_NewsRecommentStockDetailPage?symbol=$stockSymbol');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      final data = jsonDecode(response.body);
      throw (data['error'] ?? 'Unknown error');
    }
  }

}
