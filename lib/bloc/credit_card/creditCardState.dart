import 'package:equatable/equatable.dart';

class CreditCardState extends Equatable {
  final List<Map<String, String>> cards;
  final bool isLoading;

  const CreditCardState({this.cards = const [], this.isLoading = true});

  CreditCardState copyWith({
    List<Map<String, String>>? cards,
    List<Map<String, String>>? holdingStocks,
    bool? isLoading,
  }) {
    return CreditCardState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [cards, isLoading];
}
