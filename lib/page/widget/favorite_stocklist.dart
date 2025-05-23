import 'package:flutter/material.dart';

class FavoriteStocklist extends StatefulWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final bool isPositive;
  final VoidCallback? onDelete;

  const FavoriteStocklist({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.isPositive,
    this.onDelete,
  }) : super(key: key);

  @override
  _FavoriteStocklistState createState() => _FavoriteStocklistState();
}

class _FavoriteStocklistState extends State<FavoriteStocklist> {
  bool showDelete = false;

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xff14213D);
    final textColor2 = const Color(0xff606060);

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          right: showDelete ? 0 : -80,
          top: 0,
          bottom: 0,
          width: 80,
          child: Container(
            color: Colors.red,
            child: GestureDetector(
              onTap: () {
                if (widget.onDelete != null) widget.onDelete!();
              },
              child: Center(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -5) {
              setState(() {
                showDelete = true;
              });
            } else if (details.delta.dx > 5) {
              setState(() {
                showDelete = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: EdgeInsets.only(right: showDelete ? 80 : 0),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
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
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 12, color: textColor2),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text(widget.price), Text(widget.change)],
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
