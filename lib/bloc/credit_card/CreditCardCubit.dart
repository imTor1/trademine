import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import 'dart:math';

class CreditCardCubit extends Cubit<CreditCardState> {
  CreditCardCubit() : super(const CreditCardState());

  void fetchCards() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final sampleCards = List.generate(5, (index) {
      final typeCard = (index % 2 == 0) ? 'Real' : 'Demo';
      final number = '${random.nextInt(99999) + 10000} USD';
      final names = ['Jon Doe', 'Jane Smith', 'Alice', 'Bob', 'Charlie'];
      final expMonth = random.nextInt(12) + 1;
      final expYear = 23 + random.nextInt(5);

      return {
        'typeCard': typeCard,
        'number': number,
        'name': names[index % names.length],
        'exp': '${expMonth.toString().padLeft(2, '0')}/$expYear',
      };
    });

    emit(state.copyWith(cards: sampleCards, isLoading: false));
  }
}
