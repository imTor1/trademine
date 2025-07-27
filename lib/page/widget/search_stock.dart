import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';

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
  bool follow = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowed();
  }

  Future<void> checkIfFollowed() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      if (token == null) return;

      final List<dynamic> favorites = await AuthServiceUser.ShowFavoriteStock(
        token,
      );
      if (!mounted) return;
      final isFollowed = favorites.any(
        (item) => item['StockSymbol'] == widget.symbol,
      );

      setState(() {
        follow = isFollowed;
      });
    } catch (e) {
      if (!mounted)
        return AppSnackbar.showError(
          context,
          'Error checking followed stock: $e',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
    }
  }

  Future<void> FollowStock() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      await AuthServiceUser.followStock(token!, widget.symbol);
      setState(() {
        follow = !follow;
      });
    } catch (e) {
      AppSnackbar.showError(
        context,
        'Error : $e',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StockDetail(StockSymbol: widget.symbol),
                ),
              ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            follow
                                ? Icons.favorite_sharp
                                : Icons.favorite_border,
                            color:
                                follow
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                          ),
                          onPressed: () async {
                            if (follow) {
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
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Unfollow'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                try {
                                  final storage = FlutterSecureStorage();
                                  final String? token = await storage.read(
                                    key: 'auth_token',
                                  );
                                  await AuthServiceUser.unfollowStock(
                                    token!,
                                    widget.symbol,
                                  );
                                  setState(() {
                                    follow = false;
                                  });
                                } catch (e) {
                                  AppSnackbar.showError(
                                    context,
                                    'Error: $e',
                                    Icons.error,
                                    Theme.of(context).colorScheme.error,
                                  );
                                }
                              }
                            } else {
                              FollowStock();
                            }
                          },
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.change,
                          style: TextStyle(
                            color:
                                widget.change.trim().startsWith('-')
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(color: Theme.of(context).dividerColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
