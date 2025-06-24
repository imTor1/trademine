import 'package:flutter/material.dart';
import 'package:trademine/theme/app_styles.dart';

class FavoriteStocklist extends StatefulWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final VoidCallback? onDelete;

  const FavoriteStocklist({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    this.onDelete,
  }) : super(key: key);
  @override
  _FavoriteStocklistState createState() => _FavoriteStocklistState();
}

class _FavoriteStocklistState extends State<FavoriteStocklist> {
  bool showDelete = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 80,
              color: AppColor.errorColor,
              child: GestureDetector(
                onTap: () {
                  if (widget.onDelete != null) widget.onDelete!();
                },
                child: Center(
                  child: Text(
                    'DELETE',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),

        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -1) {
              setState(() {
                showDelete = true;
              });
            } else if (details.delta.dx > 1) {
              setState(() {
                showDelete = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(showDelete ? -80 : 0, 0, 0),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.price} USD',
                          style: Theme.of(context).textTheme.bodyMedium,
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
        ),
      ],
    );
  }
}
