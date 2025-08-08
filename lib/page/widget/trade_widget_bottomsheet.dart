import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trademine/utils/snackbar.dart';

// MODEL สำหรับส่งค่ากลับ
class TradeResult {
  final String stockSymbol;
  final String tradeType;
  final String amount;

  TradeResult({
    required this.stockSymbol,
    required this.tradeType,
    required this.amount,
  });
}

class TradeBottomSheet extends StatefulWidget {
  final String? stockSymbol;
  final String? selectedTradeType;

  const TradeBottomSheet({
    super.key,
    required this.stockSymbol,
    required this.selectedTradeType,
  });

  @override
  State<TradeBottomSheet> createState() => _TradeBottomSheetState();
}

class _TradeBottomSheetState extends State<TradeBottomSheet> {
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Purchase Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 25),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.wallet),
                    labelText: widget.stockSymbol ?? 'Stock',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.rightLeft),
                    labelText: widget.selectedTradeType ?? 'Buy/Sell',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.confirmation_num_rounded),
                    hintText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (amountController.text.trim().isEmpty) {
                        AppSnackbar.showError(
                          context,
                          'Enter Amount',
                          Icons.error,
                          Theme.of(context).colorScheme.error,
                        );
                      } else {
                        final result = TradeResult(
                          stockSymbol: widget.stockSymbol ?? '',
                          tradeType: widget.selectedTradeType ?? '',
                          amount: amountController.text.trim(),
                        );
                        Navigator.of(context).pop(result);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
