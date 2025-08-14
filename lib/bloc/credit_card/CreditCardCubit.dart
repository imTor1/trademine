import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'dart:math';

import '../../services/portfolio.dart';

class CreditCardCubit extends Cubit<CreditCardState> {
  CreditCardCubit() : super(const CreditCardState());

  void fetchCards() async {
    emit(state.copyWith(isLoading: true));

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final portfolio = await AuthServicePortfolio.Portfolio(token!);

    final list = 1;
    final creditCards = List.generate(list, (index) {
      final typeCard = 'Demo';
      final number = portfolio['data']['Balance'].toString();
      final name = 'XXXX XXXX';
      final expMonth = 'XX';
      final expYear = 'XX';

      return {
        'typeCard': typeCard,
        'number': number,
        'name': name,
        'exp': '${expMonth.toString().padLeft(2, '0')}/$expYear',
      };
    });

    emit(state.copyWith(cards: creditCards, isLoading: false));
  }

  void deleteAllCards() {
    emit(state.copyWith(cards: []));
  }
}
