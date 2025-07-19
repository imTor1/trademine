import 'package:flutter/material.dart';
import 'package:trademine/theme/app_styles.dart';

class TransactionHistory extends StatefulWidget {
  final String symbol;
  final String name;
  final String price;
  final String date;
  const TransactionHistory({
    super.key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.date,
  });

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.symbol,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.price} USD',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text('Date : ${widget.date}'),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: AppColor.divider),
            ],
          ),
        ],
      ),
    );
  }
}
