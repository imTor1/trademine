import 'package:equatable/equatable.dart';

class HomePageState extends Equatable {
  final bool isLoading;
  final List<dynamic> favoriteStocks;
  final List<dynamic> topStocks;
  final List<dynamic> latestNews;
  final String image;
  final bool isUnauthenticated;

  const HomePageState({
    this.isLoading = true,
    this.favoriteStocks = const [],
    this.topStocks = const [],
    this.latestNews = const [],
    this.image = '',
    this.isUnauthenticated = false,
  });

  HomePageState copyWith({
    bool? isLoading,
    List<dynamic>? favoriteStocks,
    List<dynamic>? topStocks,
    List<dynamic>? latestNews,
    String? image,
    bool? isUnauthenticated,
  }) {
    return HomePageState(
      isLoading: isLoading ?? this.isLoading,
      favoriteStocks: favoriteStocks ?? this.favoriteStocks,
      topStocks: topStocks ?? this.topStocks,
      latestNews: latestNews ?? this.latestNews,
      image: image ?? this.image,
      isUnauthenticated: isUnauthenticated ?? this.isUnauthenticated,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    favoriteStocks,
    topStocks,
    latestNews,
    image,
    isUnauthenticated,
  ];
}
