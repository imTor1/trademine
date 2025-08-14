import 'package:flutter/material.dart';
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
import 'package:trademine/theme/app_styles.dart';

class TransactionHistory extends StatelessWidget {
  final String symbol;
  final String tradetype;
  final String price;
  final String quantity;
  final String tradedate;

  const TransactionHistory({
    super.key,
    required this.symbol,
    required this.tradetype,
    required this.price,
    required this.quantity,
    required this.tradedate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StockDetail(StockSymbol: symbol)),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: 7,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        tradetype.toLowerCase() == 'sell'
                            ? Colors.red
                            : Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Type : ${tradetype.toUpperCase()}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${price} USD (${quantity})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$tradedate',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Theme.of(context).dividerColor),
          ],
        ),
      ),
    );
  }
}
