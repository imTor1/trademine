import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController symbolController = TextEditingController();
  late String _tradeType;

  @override
  void dispose() {
    amountController.dispose();
    symbolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tradeType = (widget.selectedTradeType ?? 'Buy');
    if ((widget.stockSymbol ?? '').isNotEmpty &&
        symbolController.text.isEmpty) {
      symbolController.text = widget.stockSymbol!;
    }
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
                (widget.stockSymbol == null || widget.stockSymbol!.isEmpty)
                    ? TextField(
                      controller: symbolController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.wallet),
                        hintText: 'Stock Symbol (e.g., AAPL)',
                        border: OutlineInputBorder(),
                      ),
                    )
                    : TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.wallet),
                        labelText: widget.stockSymbol ?? 'Stock',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                const SizedBox(height: 16),
                (widget.selectedTradeType == null ||
                        widget.selectedTradeType!.isEmpty)
                    ? Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Buy'),
                          selected: _tradeType.toLowerCase() == 'buy',
                          onSelected: (v) {
                            setState(() => _tradeType = 'Buy');
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Sell'),
                          selected: _tradeType.toLowerCase() == 'sell',
                          onSelected: (v) {
                            setState(() => _tradeType = 'Sell');
                          },
                        ),
                      ],
                    )
                    : TextField(
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                  ],
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
                      final text = amountController.text.trim();
                      final value = double.tryParse(text);
                      final symbol =
                          symbolController.text.trim().isEmpty
                              ? (widget.stockSymbol ?? '').trim()
                              : symbolController.text.trim();
                      if (symbol.isEmpty) {
                        AppSnackbar.showError(
                          context,
                          'Please enter a stock symbol',
                          Icons.error,
                          Theme.of(context).colorScheme.error,
                        );
                        return;
                      }
                      if (text.isEmpty || value == null || value <= 0) {
                        AppSnackbar.showError(
                          context,
                          'Please enter a valid amount (> 0)',
                          Icons.error,
                          Theme.of(context).colorScheme.error,
                        );
                      } else {
                        final result = TradeResult(
                          stockSymbol: symbol,
                          tradeType: (widget.selectedTradeType ?? _tradeType),
                          amount: text,
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
