import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/holdingStocksState.dart';
import '../../services/portfolio.dart';

class HoldingStocksCubit extends Cubit<HoldingStocksState> {
  HoldingStocksCubit() : super(const HoldingStocksState());

  Future<void> fetchHolding() async {
    if (!isClosed) emit(state.copyWith(isLoading: true));

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        if (!isClosed) {
          emit(state.copyWith(holdingStocks: const [], isLoading: false));
        }
        return;
      }

      final resp = await AuthServicePortfolio.Portfolio(token);

      final data = (resp is Map<String, dynamic>) ? resp['data'] : null;
      final holdingsRaw =
          (data is Map<String, dynamic>) ? data['holdings'] : null;
      final List<dynamic> holdingsList =
          (holdingsRaw is List) ? holdingsRaw : const [];

      final holdingStocks =
          holdingsList.map<Map<String, String>>((item) {
            final m = (item is Map) ? item : const <String, dynamic>{};
            return {
              'StockSymbol': m['StockSymbol']?.toString() ?? '',
              'Quantity': m['Quantity']?.toString() ?? '0',
              'AvgBuyPriceUSD': m['AvgBuyPriceUSD']?.toString() ?? '0',
              'MarketStatus':
                  (m['MarketStatus'] ?? m['Market'] ?? '').toString(),
              'UnrealizedPLPercent':
                  m['UnrealizedPLPercent']?.toString() ?? '0',
            };
          }).toList();

      if (!isClosed) {
        emit(state.copyWith(holdingStocks: holdingStocks, isLoading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> resetHoldingStocks() async {
    if (!isClosed) emit(const HoldingStocksState());
  }
}
