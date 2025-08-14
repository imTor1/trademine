import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/credit_card/HoldingStockCubit.dart';
import 'package:trademine/bloc/credit_card/TransactionCubit.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import 'package:trademine/bloc/credit_card/holdingStocksState.dart';
import 'package:trademine/bloc/credit_card/transactionState.dart';
import 'package:trademine/page/loading_page/TransactionHistoryShimmer.dart';
import 'package:trademine/page/setting_card/card_config.dart';
import 'package:trademine/page/setting_card/create_card.dart';
import 'package:trademine/page/widget/credit_card/addnewDemoCard.dart';
import 'package:trademine/page/widget/credit_card/credit_card.dart';
import 'package:trademine/page/widget/transactionHistory.dart';
import 'package:trademine/page/widget/transaction_history.dart';
import 'package:trademine/page/widget/trade_widget_bottomsheet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/services/trade_service.dart';
import 'package:trademine/utils/snackbar.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  int _transactionViewIndex = 0;
  late PageController _pageController;
  final List<String> currencies = ['USD', 'THB'];
  String _selectedCurrency = 'USD';

  // Remove unused demo data
  List<Map<String, String>> _currentTransactionList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.95,
      initialPage: _selectedIndex,
    );
    _loadInitialData();
  }

  String _formatDate(dynamic value) {
    try {
      if (value == null) return '-';
      // If it's already DateTime
      if (value is DateTime) {
        return DateFormat('d MMM yyyy').format(value.toLocal());
      }
      // If it's an int (timestamp seconds or ms)
      if (value is int) {
        // Heuristic: treat > 10^12 as ms
        final isMs = value > 1000000000000;
        final dt = DateTime.fromMillisecondsSinceEpoch(
          isMs ? value : value * 1000,
        );
        return DateFormat('d MMM yyyy').format(dt.toLocal());
      }
      // If it's string parseable
      if (value is String) {
        // Try ISO-8601
        final dt = DateTime.parse(value);
        return DateFormat('d MMM yyyy').format(dt.toLocal());
      }
      return value.toString();
    } catch (_) {
      return value.toString();
    }
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait<void>([
        Future.microtask(() => context.read<CreditCardCubit>().fetchCards()),
        Future.microtask(
          () => context.read<HoldingStocksCubit>().fetchHolding(),
        ),
        Future.microtask(
          () => context.read<TransactionCubit>().fetchTransaction(),
        ),
      ]);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Failed to load data: $e',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshHoldingStocks() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait<void>([
        Future.microtask(
          () => context.read<HoldingStocksCubit>().fetchHolding(),
        ),
        Future.microtask(() => context.read<CreditCardCubit>().fetchCards()),
        Future.microtask(
          () => context.read<TransactionCubit>().fetchTransaction(),
        ),
      ]);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Failed to refresh data: $e',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCardCubit, CreditCardState>(
      builder: (context, state) {
        final cardsData = state.cards ?? [];

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildAssetsHeader(cardsData),
                    _buildCardsSection(cardsData),
                    const SizedBox(height: 15),
                    if (cardsData.isNotEmpty) ...[
                      _buildActionButtons(),
                      const SizedBox(height: 15),
                      _buildTotalValueCard(),
                      const SizedBox(height: 15),
                      _buildToggleButtons(),
                    ],
                  ],
                ),
              ),
              _buildTransactionsList(cardsData),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return const SliverAppBar(
      centerTitle: false,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Text('Trade'),
    );
  }

  Widget _buildAssetsHeader(List<Map<String, dynamic>> cardsData) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Assets (${cardsData.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCardsSection(List<Map<String, dynamic>> cardsData) {
    if (cardsData.isEmpty) {
      return SizedBox(
        height: 250,
        child: PageView.builder(
          itemCount: 1,
          onPageChanged: (index) {},
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: AddNewCardWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateCard()),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: cardsData.length,
        onPageChanged: (index) {
          if (mounted) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        itemBuilder: (context, index) {
          final card = cardsData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: CreditCardWidget(
                  typeCard: card['typeCard']?.toString() ?? '',
                  number: card['number']?.toString() ?? '',
                  name: card['name']?.toString() ?? '',
                  exp: card['exp']?.toString() ?? '',
                  isSelected: index == _selectedIndex,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    final labels = ['Buy', 'Sell', 'More', 'Refresh'];
    final icons = [
      FontAwesomeIcons.arrowUp,
      FontAwesomeIcons.arrowDown,
      FontAwesomeIcons.ellipsis,
      FontAwesomeIcons.rotate,
    ];
    final colors = [
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.primary,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => _handleActionButton(index),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(18),
                backgroundColor: colors[index],
              ),
              child: Icon(icons[index], color: Colors.white, size: 24),
            ),
            if (labels[index].isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                labels[index],
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        );
      }),
    );
  }

  Future<void> _handleActionButton(int index) async {
    final cardsData = context.read<CreditCardCubit>().state.cards ?? [];

    switch (index) {
      case 0:
        await _openTradeSheet(context, type: 'Buy');
        break;
      case 1:
        await _openTradeSheet(context, type: 'Sell');
        break;
      case 2:
        if (cardsData.isNotEmpty && _selectedIndex < cardsData.length) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DemoCard(CardData: [cardsData[_selectedIndex]]),
            ),
          );
        }
        break;
      case 3:
        await _refreshHoldingStocks();
        break;
    }
  }

  Widget _buildTotalValueCard() {
    return BlocBuilder<CreditCardCubit, CreditCardState>(
      builder: (context, state) {
        final cardsData = state.cards ?? [];
        if (cardsData.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: BlocBuilder<HoldingStocksCubit, HoldingStocksState>(
            builder: (context, state) {
              final holdingStocks = state.holdingStocks ?? [];
              final isLoading = state.isLoading;

              double totalValue = 0.0;
              if (holdingStocks.isNotEmpty) {
                for (var stock in holdingStocks) {
                  final price =
                      double.tryParse(
                        stock['AvgBuyPriceUSD']?.toString() ?? '0',
                      ) ??
                      0.0;
                  final quantity =
                      double.tryParse(stock['Quantity']?.toString() ?? '0') ??
                      0.0;
                  totalValue += price * quantity;
                }
              }

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 5, top: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.moneyBill),
                          const SizedBox(width: 8),
                          Text(
                            'Total Value of Holdings',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            '\$${totalValue.toStringAsFixed(2)}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                    ],
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleButtons(
            isSelected: [
              _transactionViewIndex == 0,
              _transactionViewIndex == 1,
            ],
            onPressed: (int index) {
              if (mounted) {
                setState(() {
                  _transactionViewIndex = index;
                });
              }
            },
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.onSurface,
            constraints: BoxConstraints(
              minHeight: 40,
              minWidth: MediaQuery.of(context).size.width * 0.45,
            ),
            children: const [Text('Transactions'), Text('Holding Stocks')],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<Map<String, dynamic>> cardsData) {
    if (cardsData.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return BlocBuilder<HoldingStocksCubit, HoldingStocksState>(
      builder: (context, holdingState) {
        final holdingStocks = holdingState.holdingStocks ?? [];
        final isHoldingLoading = holdingState.isLoading;

        if (_transactionViewIndex == 0) {
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              final transactionHistory =
                  transactionState.transactionHistory ?? [];
              final isTransactionLoading = transactionState.isLoading;

              if (isTransactionLoading) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const TransactionHistoryShimmer(),
                    childCount: 6,
                  ),
                );
              }

              if (transactionHistory.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No Transactions available')),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: 8,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final history = transactionHistory[index];
                    return TransactionHistory(
                      symbol: history['StockSymbol']?.toString() ?? '',
                      tradetype: history['TradeType']?.toString() ?? '',
                      price: history['Price']?.toString() ?? '',
                      quantity: history['Quantity']?.toString() ?? '',
                      tradedate: _formatDate(
                        history['TradeDate']?.toString() ?? '',
                      ),
                    );
                  }, childCount: transactionHistory.length),
                ),
              );
            },
          );
        } else {
          if (isHoldingLoading) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const TransactionHistoryShimmer(),
                childCount: 10,
              ),
            );
          }

          if (holdingStocks.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(child: Text('No Stock Holding available')),
            );
          }

          return SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: 8,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final history = holdingStocks[index];
                final price =
                    double.tryParse(
                      history['AvgBuyPriceUSD']?.toString() ?? '0',
                    ) ??
                    0.0;
                final quantity =
                    double.tryParse(history['Quantity']?.toString() ?? '0') ??
                    0.0;
                final priceSumQuantity = price * quantity;
                final finalPriceSumQuantity =
                    (priceSumQuantity * 1000).truncateToDouble() / 1000;

                return HoldingStocks(
                  symbol: history['StockSymbol']?.toString() ?? '',
                  name: history['StockSymbol']?.toString() ?? '',
                  price: finalPriceSumQuantity.toString(),
                  marketstatus: history['MarketStatus']?.toString() ?? '',
                  quantity: quantity.toInt(),
                  unrealizedPLPercent:
                      history['UnrealizedPLPercent']?.toString() ?? '',
                );
              }, childCount: holdingStocks.length),
            ),
          );
        }
      },
    );
  }

  Future<void> _openTradeSheet(
    BuildContext context, {
    required String type,
  }) async {
    try {
      final result = await showModalBottomSheet<TradeResult>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder:
            (_) => TradeBottomSheet(stockSymbol: '', selectedTradeType: type),
      );

      if (result == null || !mounted) return;

      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        if (mounted) {
          AppSnackbar.showWarning(context, 'Please login');
        }
        return;
      }

      final message = await ServiceTrade.TradeDemo(
        token,
        result.stockSymbol,
        result.amount,
        result.tradeType.toLowerCase(),
      );

      if (mounted) {
        AppSnackbar.showSuccess(context, message ?? 'Trade success');
        await _refreshHoldingStocks();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Trade failed: $e',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
      }
    }
  }
}
