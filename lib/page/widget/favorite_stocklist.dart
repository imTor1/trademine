import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/utils/snackbar.dart';

class FavoriteStocklist extends StatefulWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final String market;
  final VoidCallback? onDelete;

  const FavoriteStocklist({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.market,
    this.onDelete,
  }) : super(key: key);
  @override
  _FavoriteStocklistState createState() => _FavoriteStocklistState();
}

class _FavoriteStocklistState extends State<FavoriteStocklist> {
  String _getCurrencySymbol(String market) {
    switch (market.toUpperCase()) {
      case 'THAILAND':
        return 'THB';
      case 'AMERICA':
        return 'USD';
      default:
        return '??';
    }
  }

  Future<void> DeleteStockFavorite() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      await AuthServiceUser.unfollowStock(token!, widget.symbol);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        'Error : $e',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

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
                onTap: () async {
                  final confirm = await showCupertinoDialog<bool>(
                    context: context,
                    builder:
                        (context) => CupertinoAlertDialog(
                          title: const Text('Confirm'),
                          content: Text(
                            'Are you sure you want to unfollow ${widget.symbol}?',
                          ),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Unfollow'),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    await DeleteStockFavorite();
                    widget.onDelete?.call();
                  }
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockDetail(StockSymbol: widget.symbol),
              ),
            );
          },
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
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.price} ${_getCurrencySymbol(widget.market)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.change,
                          style: TextStyle(
                            color:
                                widget.change.trim().startsWith('-')
                                    ? AppColor.errorColor
                                    : AppColor.greenColor,
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
