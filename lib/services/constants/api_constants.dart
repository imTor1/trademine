class ApiConstants {
  static const String baseUrl = "http://localhost:3000";
  static const String login = "$baseUrl/api/login";
  static const String register_email = "$baseUrl/api/register/email";
  static const String register_otp = "$baseUrl/api/register/verify-otp";
  static const String register_password = "$baseUrl/api/register/set-password";
  static const String register_profile = "$baseUrl/api/set-profile";
  static const String forgetpassword_email = "$baseUrl/api/forgot-password";
  static const String profile = "$baseUrl";
  static const String stock_favorite = "$baseUrl/api/favorites";
  static const String latest_news = "$baseUrl/api/latest-news";
  static const String topStock = "$baseUrl/api/top-10-stocks";
  static const String search = "$baseUrl/api/search";
  static const String news_detail = "$baseUrl/api/news-detail";
  static const String stock_detail = "$baseUrl/api/stock-detail/";
}
