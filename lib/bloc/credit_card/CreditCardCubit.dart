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

    final storage = await FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final Portfolio = await AuthServicePortfolio.Portfolio(token!);

    final list = 1;
    final CreditCard = List.generate(list, (index) {
      final typeCard = 'Demo';
      final number = Portfolio['data']['Balance'].toString();
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

    emit(state.copyWith(cards: CreditCard, isLoading: false));
  }
}
