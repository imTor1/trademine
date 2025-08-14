import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/holdingStocksState.dart';
import '../../services/portfolio.dart';

class HoldingStocksCubit extends Cubit<HoldingStocksState> {
  HoldingStocksCubit() : super(const HoldingStocksState());

  void fetchHolding() async {
    emit(state.copyWith(isLoading: true));

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final portfolio = await AuthServicePortfolio.Portfolio(token!);

    final holdingStocksList = portfolio['data']['holdings'] as List;

    final holdingStocks =
        holdingStocksList.map<Map<String, String>>((item) {
          return {
            'StockSymbol': item['StockSymbol'].toString(),
            'Quantity': item['Quantity'].toString(),
            'AvgBuyPriceUSD': item['AvgBuyPriceUSD'].toString(),
            'MarketStatus': item['MarketStatus'].toString(),
            'UnrealizedPLPercent': item['UnrealizedPLPercent'].toString(),
          };
        }).toList();

    emit(state.copyWith(holdingStocks: holdingStocks, isLoading: false));
  }

  Future<void> ResetHoldingStocks() async {
    emit(const HoldingStocksState());
  }
}
