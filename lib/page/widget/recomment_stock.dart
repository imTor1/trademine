import 'package:flutter/material.dart';
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';

class RecommentStock extends StatefulWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;

  const RecommentStock({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  }) : super(key: key);

  _RecommentStockState createState() => _RecommentStockState();
}

class _RecommentStockState extends State<RecommentStock> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () async {
        final changed = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StockDetail(StockSymbol: widget.symbol),
          ),
        );
        if (changed == true) {
          context.read<HomePageCubit>().fetchData();
        }
      },
      child: IntrinsicHeight(
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.change.trim().startsWith('-')
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.change}%',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest price',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.price,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                  ),
                  Text(
                    'USD',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
