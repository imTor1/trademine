import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/home/homepageState.dart';
import 'package:trademine/services/news_service.dart';
import 'package:trademine/services/stock_service.dart';
import 'package:trademine/services/user_service.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());

  Future<void> fetchData() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      final String? userId = await storage.read(key: 'user_Id');

      if (token == null || userId == null) {
        emit(state.copyWith(isUnauthenticated: true));
        return;
      }

      final favoriteStock = await AuthServiceUser.ShowFavoriteStock(token);
      final profile = await AuthServiceUser.ProfileFecthData(userId, token);
      final topStock = await AuthServiceStock.RecommentStock();
      final latestNews = await AuthServiceNews.LatestNews(limit: 10, offset: 0);

      emit(
        state.copyWith(
          isLoading: false,
          favoriteStocks: favoriteStock ?? [],
          topStocks: topStock ?? [],
          latestNews: latestNews['news'],
          image: profile['profileImage'] ?? '',
        ),
      );
    } catch (e) {
      print('Error fetching data: $e');
      emit(state.copyWith(isLoading: false));
    }
  }
}
