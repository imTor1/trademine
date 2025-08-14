import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/page/%20stock_detail/stock_detail.dart';
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
  State<FavoriteStocklist> createState() => _FavoriteStocklistState();
}

class _FavoriteStocklistState extends State<FavoriteStocklist> {
  final storage = const FlutterSecureStorage();
  bool _isDeleting = false;

  String _getCurrencySymbol(String market) {
    switch (market.toUpperCase()) {
      case 'THAILAND':
        return 'THB';
      case 'AMERICA':
        return 'USD';
      default:
        return '—';
    }
  }

  Future<void> _deleteStockFavorite() async {
    try {
      if (_isDeleting) return;
      setState(() => _isDeleting = true);
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('No token found');
      }
      await AuthServiceUser.unfollowStock(token, widget.symbol);
      if (!mounted) return;
      setState(() {
        showDelete = false;
        _isDeleting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      AppSnackbar.showError(
        context,
        'Error: $e',
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
        // ปุ่ม DELETE ด้านหลัง
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 80,
              color: Theme.of(context).colorScheme.error,
              child: GestureDetector(
                onTap: () async {
                  if (_isDeleting) return;
                  final confirm = await showCupertinoDialog<bool>(
                    context: context,
                    builder:
                        (_) => CupertinoAlertDialog(
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
                    await _deleteStockFavorite();
                    widget.onDelete?.call();
                  }
                },
                child: Center(
                  child:
                      _isDeleting
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'DELETE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),

        // รายการหุ้น
        GestureDetector(
          onTap: () async {
            if (showDelete || _isDeleting) return;
            final changed = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockDetail(StockSymbol: widget.symbol),
              ),
            );
            if (changed == true) {
              widget.onDelete?.call();
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -1) {
              setState(() => showDelete = true);
            } else if (details.delta.dx > 1) {
              setState(() => showDelete = false);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(showDelete ? -100 : 0, 0, 0),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ข้อมูลหุ้นด้านซ้าย
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    // ราคา + การเปลี่ยนแปลงด้านขวา
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.price} ${_getCurrencySymbol(widget.market)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.change}%',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
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
