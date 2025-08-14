import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/transactionState.dart';
import '../../services/portfolio.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(const TransactionState());

  void fetchTransaction() async {
    emit(state.copyWith(isLoading: true));

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final transactionHistory = await AuthServicePortfolio.TransactionHistory(
      token!,
    );

    final transactionHistoryList = transactionHistory['data'] as List;

    print(transactionHistoryList);

    final TransactionHistory =
        transactionHistoryList.map<Map<String, String>>((item) {
          return {
            'StockSymbol': item['StockSymbol'].toString(),
            'TradeType': item['TradeType'].toString(),
            'Quantity': item['Quantity'].toString(),
            'Price': item['Price'].toString(),
            'TradeDate': item['TradeDate'].toString(),
          };
        }).toList();

    emit(
      state.copyWith(transactionHistory: TransactionHistory, isLoading: false),
    );
  }

  Future<void> ResetTransactionStocks() async {
    emit(const TransactionState());
  }
}
