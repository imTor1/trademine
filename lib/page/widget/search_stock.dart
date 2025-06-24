import 'package:flutter/material.dart';
import 'package:trademine/theme/app_styles.dart';

class SearchStock extends StatefulWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;

  const SearchStock({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  }) : super(key: key);
  @override
  _SearchStockState createState() => _SearchStockState();
}

class _SearchStockState extends State<SearchStock> {
  bool showDelete = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.star_border, color: Colors.grey),
                        onPressed: () {},
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.symbol,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              widget.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.price} USD',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.change,
                        style: TextStyle(
                          color:
                              widget.change.trim().startsWith('+')
                                  ? AppColor.greenColor
                                  : AppColor.errorColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: AppColor.divider),
            ],
          ),
        ),
      ],
    );
  }
}
