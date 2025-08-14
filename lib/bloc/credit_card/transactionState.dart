import 'package:equatable/equatable.dart';

class TransactionState extends Equatable {
  final List<Map<String, String>> transactionHistory;
  final bool isLoading;

  const TransactionState({
    this.transactionHistory = const [],
    this.isLoading = true,
  });

  TransactionState copyWith({
    List<Map<String, String>>? transactionHistory,
    bool? isLoading,
  }) {
    return TransactionState(
      transactionHistory: transactionHistory ?? this.transactionHistory,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [transactionHistory, isLoading];
}
