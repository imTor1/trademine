import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/transactionState.dart';
import '../../services/portfolio.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(const TransactionState());

  Future<void> fetchTransaction() async {
    emit(state.copyWith(isLoading: true));

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, transactionHistory: const []));
        }
        return;
      }

      final resp = await AuthServicePortfolio.TransactionHistory(token);

      final dynamic rawData =
          (resp is Map<String, dynamic>) ? resp['data'] : null;
      final List<dynamic> list = (rawData is List) ? rawData : const [];

      final history =
          list.map<Map<String, String>>((item) {
            final m = (item is Map) ? item : const <String, dynamic>{};
            return {
              'StockSymbol': m['StockSymbol']?.toString() ?? '',
              'TradeType': m['TradeType']?.toString() ?? '',
              'Quantity': m['Quantity']?.toString() ?? '0',
              'Price': m['Price']?.toString() ?? '0',
              'TradeDate': m['TradeDate']?.toString() ?? '',
            };
          }).toList();

      if (!isClosed) {
        emit(state.copyWith(transactionHistory: history, isLoading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> resetTransactionStocks() async {
    if (!isClosed) emit(const TransactionState());
  }
}
