import 'package:equatable/equatable.dart';

class HoldingStocksState extends Equatable {
  final List<Map<String, String>> holdingStocks;
  final bool isLoading;

  const HoldingStocksState({
    this.holdingStocks = const [],
    this.isLoading = true,
  });

  HoldingStocksState copyWith({
    List<Map<String, String>>? holdingStocks,
    bool? isLoading,
  }) {
    return HoldingStocksState(
      holdingStocks: holdingStocks ?? this.holdingStocks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [holdingStocks, isLoading];
}
