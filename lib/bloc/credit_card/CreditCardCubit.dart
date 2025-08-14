import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import '../../services/portfolio.dart';

class CreditCardCubit extends Cubit<CreditCardState> {
  CreditCardCubit() : super(const CreditCardState());

  Future<void> fetchCards() async {
    if (!isClosed) emit(state.copyWith(isLoading: true));

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, cards: const []));
        }
        return;
      }

      final resp = await AuthServicePortfolio.Portfolio(token);

      final data = (resp is Map<String, dynamic>) ? resp['data'] : null;
      final balanceRaw =
          (data is Map<String, dynamic>) ? data['Balance'] : null;
      final balanceStr = (balanceRaw == null) ? '0.00' : balanceRaw.toString();

      final creditCards = <Map<String, String>>[
        {
          'typeCard': 'Demo',
          'number': balanceStr,
          'name': 'XXXX XXXX',
          'exp': 'XX/XX',
        },
      ];

      if (!isClosed) {
        emit(state.copyWith(cards: creditCards, isLoading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  void deleteAllCards() {
    if (!isClosed) emit(state.copyWith(cards: []));
  }
}
