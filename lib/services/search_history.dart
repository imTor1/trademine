import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'search_keywords';

  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> saveSearchKeyword(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];

    history.remove(keyword);
    history.insert(0, keyword);

    // จำกัดไว้ที่ 10 คำ
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await prefs.setStringList(_key, history);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
