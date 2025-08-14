import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trademine/page/%20stock_detail/recommentNews_stockDetail.dart';
import 'package:trademine/page/%20stock_detail/widget_detail.dart';
import 'package:trademine/page/widget/trade_widget_bottomsheet.dart';
import 'package:trademine/services/stock_service.dart';
import 'package:intl/intl.dart';
import 'package:trademine/services/trade_service.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';
import 'package:trademine/bloc/credit_card/HoldingStockCubit.dart';
import '../../services/news_service.dart';

class StockDetail extends StatefulWidget {
  final String StockSymbol;
  const StockDetail({super.key, required this.StockSymbol});

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  bool follow = false;
  bool favoritesChanged = false;
  bool _isTogglingFavorite = false;
  bool _isTrading = false;
  Map<String, dynamic>? detailStock;
  List<dynamic>? newsRecommnet;
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  List<CandleData> chartData = [];
  String selectedTimeframe = "5D";
  bool isLoading = false;
  String? TradeType;

  final Map<String, String> timeframeLabels = {
    "5D": "5D",
    "1M": "1M",
    "3M": "3M",
    "6M": "6M",
    "1Y": "1Y",
    "ALL": "ALL",
  };

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming: true,
    );

    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(enable: true),
      lineType: TrackballLineType.vertical,
      markerSettings: TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
      ),
      builder: (BuildContext context, TrackballDetails details) {
        if (details == null || details.pointIndex == null)
          return const SizedBox();

        final int pointIndex = details.pointIndex!;
        if (pointIndex < 0 || pointIndex >= chartData.length)
          return const SizedBox();

        final CandleData data = chartData[pointIndex];
        final dateStr = DateFormat('d MMM yyyy').format(data.date);
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: $dateStr',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Open: ${data.open.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'High: ${data.high.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Low: ${data.low.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Close: ${data.close.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
    fetchData();
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
        (item) => item['StockSymbol'] == widget.StockSymbol,
      );

      setState(() {
        follow = isFollowed;
      });
    } catch (e) {
      AppSnackbar.showError(
        context,
        'Error checking followed stock: $e',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

  Future<void> fetchData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final data = await AuthServiceStock.StockDetail(
        widget.StockSymbol,
        timeframe: selectedTimeframe,
      );
      final newsRecomments =
          await AuthServiceNews.getNewsRecommentStockDetailPage(
            widget.StockSymbol,
          );
      if (mounted) {
        setState(() {
          detailStock = data;
          newsRecommnet = newsRecomments;
          chartData = convertToCandleData(detailStock!);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<CandleData> convertToCandleData(Map<String, dynamic> detailStock) {
    final List<dynamic> prices = detailStock['HistoricalPrices'] ?? [];
    final List<CandleData> candles = [];
    for (var item in prices) {
      try {
        final date = DateTime.parse(item['Date']);
        final close = double.tryParse(item['ClosePrice'].toString()) ?? 0.0;
        final open = double.tryParse(item['OpenPrice'].toString()) ?? 0.0;
        final high = double.tryParse(item['HighPrice'].toString()) ?? 0.0;
        final low = double.tryParse(item['LowPrice'].toString()) ?? 0.0;
        candles.add(
          CandleData(
            date: date,
            open: open,
            high: high,
            low: low,
            close: close,
          ),
        );
      } catch (e) {
        print(e);
      }
    }
    candles.sort((a, b) => a.date.compareTo(b.date));
    if (candles.length == 1) {
      final single = candles[0];
      final prevDate = single.date.subtract(Duration(days: 1));
      candles.insert(
        0,
        CandleData(
          date: prevDate,
          open: single.open,
          high: single.high,
          low: single.low,
          close: single.close,
        ),
      );
    }
    return candles;
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

  String _formatNumber(dynamic value) {
    final numVal = double.tryParse(value?.toString() ?? '');
    if (numVal == null) return '-';
    return NumberFormat('#,##0.##').format(numVal);
  }

  bool _isThaiMarket() {
    final market =
        (detailStock?['Profile']?['Market'] ??
                detailStock?['Profile']?['Country'] ??
                detailStock?['Overview']?['Market'] ??
                '')
            .toString()
            .toUpperCase();
    return market.contains('THAI');
  }

  List<AveragePoint> computeSMA(List<CandleData> data, int period) {
    final List<AveragePoint> smaData = [];
    for (int i = period - 1; i < data.length; i++) {
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += data[i - j].close;
      }
      smaData.add(AveragePoint(date: data[i].date, value: sum / period));
    }
    return smaData;
  }

  void _openBottomSheet() async {
    final result = await showModalBottomSheet<TradeResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => TradeBottomSheet(
            stockSymbol: detailStock?['StockSymbol'],
            selectedTradeType: TradeType,
          ),
    );
    if (result != null) {
      try {
        setState(() {
          _isTrading = true;
        });
        final storage = FlutterSecureStorage();
        final token = await storage.read(key: 'auth_token');
        final trade = await ServiceTrade.TradeDemo(
          token!,
          result.stockSymbol,
          result.amount,
          result.tradeType.toLowerCase(),
        );
        if (!mounted) return;
        AppSnackbar.showError(
          context,
          trade ?? 'Trade success',
          Icons.check,
          Theme.of(context).colorScheme.secondary,
        );
        // Refresh related data
        context.read<CreditCardCubit>().fetchCards();
        context.read<HoldingStocksCubit>().fetchHolding();
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.showError(
          context,
          'Trade failed: $e',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isTrading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> descriptionTitles = [
      ['Open', 'High', 'Low'],
      ['Vol', 'P/E', 'Mkt Cap'],
      ['Market', 'Sector', 'Industry'],
    ];

    String safeGet(Map? map, String key) {
      final value = map?[key];
      return value?.toString() ?? '-';
    }

    print(detailStock?['Overview']);

    final List<List<String>> descriptionData = [
      [
        safeGet(detailStock?['Overview'], 'Open'),
        safeGet(detailStock?['Overview'], 'High'),
        safeGet(detailStock?['Overview'], 'Close'),
      ],
      [
        safeGet(detailStock?['Overview'], 'AvgVolume30D'),
        detailStock?['StockSymbol'] ?? '-',
        detailStock?['Overview']['Marketcap'] ?? '-',
      ],
      [
        safeGet(detailStock?['Profile'], 'Market'),
        safeGet(detailStock?['Profile'], 'Sector'),
        safeGet(detailStock?['Profile'], 'Industry'),
      ],
    ];
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, favoritesChanged);
        return false;
      },
      child: BlocBuilder<CreditCardCubit, CreditCardState>(
        builder: (context, state) {
          final CardsData = state.cards;
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body:
                detailStock == null
                    ? Center(child: _Loading())
                    : CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          snap: true,
                          pinned: false,
                          expandedHeight: 60,
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 1,
                          leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed:
                                () => Navigator.pop(context, favoritesChanged),
                          ),
                          title: Text(
                            detailStock?['StockSymbol'] ?? 'No Stock',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          centerTitle: true,
                          actions: [
                            IconButton(
                              icon: Icon(
                                follow
                                    ? Icons.favorite_sharp
                                    : Icons.favorite_border,
                                color:
                                    follow
                                        ? Theme.of(context).colorScheme.error
                                        : Colors.white,
                              ),
                              onPressed: () async {
                                if (_isTogglingFavorite) return;
                                if (follow == true) {
                                  try {
                                    setState(() {
                                      _isTogglingFavorite = true;
                                    });
                                    final storage = FlutterSecureStorage();
                                    final String? token = await storage.read(
                                      key: 'auth_token',
                                    );
                                    await AuthServiceUser.unfollowStock(
                                      token!,
                                      detailStock?['StockSymbol'],
                                    );
                                    setState(() {
                                      follow = false;
                                      favoritesChanged = true;
                                      _isTogglingFavorite = false;
                                    });
                                    AppSnackbar.showError(
                                      context,
                                      'Unfollow: ${detailStock?['StockSymbol']} Success',
                                      Icons.check,
                                      Theme.of(context).colorScheme.secondary,
                                    );
                                    context.read<HomePageCubit>().fetchData();
                                  } catch (e) {
                                    setState(() {
                                      _isTogglingFavorite = false;
                                    });
                                    AppSnackbar.showError(
                                      context,
                                      'Error: $e',
                                      Icons.error,
                                      Theme.of(context).colorScheme.error,
                                    );
                                  }
                                } else {
                                  try {
                                    setState(() {
                                      _isTogglingFavorite = true;
                                    });
                                    final storage = FlutterSecureStorage();
                                    final String? token = await storage.read(
                                      key: 'auth_token',
                                    );
                                    await AuthServiceUser.followStock(
                                      token!,
                                      detailStock?['StockSymbol'],
                                    );
                                    setState(() {
                                      follow = !follow;
                                      favoritesChanged = true;
                                      _isTogglingFavorite = false;
                                    });
                                    AppSnackbar.showError(
                                      context,
                                      'Follow : ${detailStock?['StockSymbol']} Success',
                                      Icons.check,
                                      Theme.of(context).colorScheme.secondary,
                                    );
                                    context.read<HomePageCubit>().fetchData();
                                  } catch (e) {
                                    setState(() {
                                      _isTogglingFavorite = false;
                                    });
                                    AppSnackbar.showError(
                                      context,
                                      'Error : $e',
                                      Icons.error,
                                      Theme.of(context).colorScheme.error,
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),

                        SliverToBoxAdapter(
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height / 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, -4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                        0.04,
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  detailStock?['StockSymbol'] ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Chip(
                                            label: Text(
                                              detailStock?['Type'] ?? '',
                                            ),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.white),
                                            side: BorderSide.none,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 0,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          const SizedBox(width: 6),
                                          Builder(
                                            builder: (_) {
                                              final rawStatus =
                                                  (detailStock?['Profile']?['MarketStatus'] ??
                                                          detailStock?['Overview']?['MarketStatus'] ??
                                                          detailStock?['Overview']?['MarketStatus'] ??
                                                          '')
                                                      .toString()
                                                      .toUpperCase();
                                              final isOpen = rawStatus.contains(
                                                'OPEN',
                                              );
                                              final display =
                                                  isOpen
                                                      ? 'open'
                                                      : (rawStatus.isEmpty
                                                          ? '-'
                                                          : 'closed');
                                              final color =
                                                  isOpen
                                                      ? Colors.green
                                                      : Colors.grey;
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(
                                                    0.15,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: color.withOpacity(
                                                      0.6,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color: color,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      display,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: color,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        detailStock?['company'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            'Price : ',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.06),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                if (detailStock?['Type'] !=
                                                    'TH Stock')
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'USD : ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary,
                                                            ),
                                                      ),
                                                      Text(
                                                        (detailStock?['ClosePrice'] ??
                                                                '-')
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.06),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'THB : ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                      ),
                                                ),
                                                Text(
                                                  (detailStock?['ClosePriceTHB'] ??
                                                          '-')
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                      const SizedBox(height: 5),

                                      Row(
                                        children: [
                                          Text(
                                            'Date : ',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.06),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${_formatDate(detailStock?['Date'])}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      Row(
                                        children: [
                                          FaIcon(
                                            (detailStock?['Change']
                                                        ?.toString()
                                                        .trim()
                                                        .startsWith('-') ??
                                                    false)
                                                ? FontAwesomeIcons.arrowDown
                                                : FontAwesomeIcons.arrowUp,
                                            color:
                                                (detailStock?['Change']
                                                            ?.toString()
                                                            .trim()
                                                            .startsWith('-') ??
                                                        false)
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.error
                                                    : Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${detailStock?['Change'] ?? '-'} %',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  (detailStock?['Change']
                                                              ?.toString()
                                                              .trim()
                                                              .startsWith(
                                                                '-',
                                                              ) ??
                                                          false)
                                                      ? Theme.of(
                                                        context,
                                                      ).colorScheme.error
                                                      : Theme.of(
                                                        context,
                                                      ).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 320,
                                  child:
                                      detailStock?['HistoricalPrices'] == null
                                          ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                          : Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.zero,
                                                child: SfCartesianChart(
                                                  margin: EdgeInsets.only(
                                                    left: 4,
                                                    right: 8,
                                                    top: 8,
                                                    bottom: 4,
                                                  ),
                                                  plotAreaBorderWidth: 0,
                                                  primaryXAxis: DateTimeAxis(
                                                    majorGridLines:
                                                        MajorGridLines(
                                                          width: 0.8,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade200,
                                                        ),
                                                    dateFormat: DateFormat(
                                                      'd MMM',
                                                    ),
                                                    edgeLabelPlacement:
                                                        EdgeLabelPlacement
                                                            .shift,
                                                    labelStyle: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  primaryYAxis: NumericAxis(
                                                    majorGridLines:
                                                        MajorGridLines(
                                                          width: 0.8,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade200,
                                                        ),
                                                    opposedPosition: true,
                                                    labelAlignment:
                                                        LabelAlignment.end,
                                                    axisLine: const AxisLine(
                                                      width: 0,
                                                    ),
                                                    majorTickLines:
                                                        const MajorTickLines(
                                                          width: 0,
                                                        ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.transparent,
                                                      fontSize: 0,
                                                    ),
                                                  ),
                                                  trackballBehavior:
                                                      _trackballBehavior,
                                                  zoomPanBehavior:
                                                      _zoomPanBehavior,
                                                  enableAxisAnimation: false,
                                                  series: <CartesianSeries>[
                                                    LineSeries<
                                                      CandleData,
                                                      DateTime
                                                    >(
                                                      dataSource: chartData,
                                                      xValueMapper:
                                                          (CandleData d, _) =>
                                                              d.date,
                                                      yValueMapper:
                                                          (CandleData d, _) =>
                                                              d.close,
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      width: 2.5,
                                                      animationDuration: 0,
                                                    ),
                                                    LineSeries<
                                                      AveragePoint,
                                                      DateTime
                                                    >(
                                                      xValueMapper:
                                                          (AveragePoint p, _) =>
                                                              p.date,
                                                      yValueMapper:
                                                          (AveragePoint p, _) =>
                                                              p.value,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      width: 1.8,
                                                      dashArray: const <double>[
                                                        6,
                                                        3,
                                                      ],
                                                      animationDuration: 0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (isLoading)
                                                Positioned.fill(
                                                  child: Container(
                                                    color: Colors.black12,
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                ),

                                const SizedBox(height: 20),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: timeframeLabels.length,
                                    separatorBuilder:
                                        (_, __) => const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final key = timeframeLabels.keys
                                          .elementAt(index);
                                      final label = timeframeLabels[key];
                                      final isSelected =
                                          key == selectedTimeframe;

                                      return ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minHeight: 30,
                                          maxHeight: 30,
                                          minWidth: 40,
                                        ),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.resolveWith<
                                                  Color
                                                >((states) {
                                                  if (states.contains(
                                                    MaterialState.pressed,
                                                  )) {
                                                    return Colors.white
                                                        .withOpacity(0.2);
                                                  }
                                                  return isSelected
                                                      ? Theme.of(
                                                        context,
                                                      ).primaryColor
                                                      : Colors.transparent;
                                                }),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                  Color
                                                >(
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                            padding: MaterialStateProperty.all<
                                              EdgeInsets
                                            >(
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 4,
                                              ),
                                            ),
                                            shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder
                                            >(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: BorderSide.none,
                                              ),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all<
                                                  double
                                                >(0),
                                          ),
                                          onPressed:
                                              isLoading
                                                  ? null
                                                  : () {
                                                    if (selectedTimeframe !=
                                                        key) {
                                                      setState(() {
                                                        selectedTimeframe = key;
                                                      });
                                                      fetchData();
                                                    }
                                                  },
                                          child: Text(
                                            label ?? key,
                                            style: TextStyle(
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                        0.04,
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                              descriptionTitles.length,
                                              (index) {
                                                return Row(
                                                  children: [
                                                    WidgetDetail(
                                                      title:
                                                          descriptionTitles[index],
                                                      data:
                                                          descriptionData[index],
                                                    ),
                                                    const VerticalDivider(
                                                      color: Colors.grey,
                                                      thickness: 1,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        if (CardsData.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed:
                                                      _isTrading
                                                          ? null
                                                          : () async {
                                                            setState(() {
                                                              TradeType = "Buy";
                                                            });
                                                            _openBottomSheet();
                                                          },
                                                  icon: const Icon(
                                                    Icons.upload,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    'Buy',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 16,
                                                        ),
                                                    backgroundColor:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed:
                                                      _isTrading
                                                          ? null
                                                          : () async {
                                                            setState(() {
                                                              TradeType =
                                                                  "Sell";
                                                            });
                                                            _openBottomSheet();
                                                          },
                                                  icon: const Icon(
                                                    Icons.download,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    'Sell',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 16,
                                                        ),
                                                    backgroundColor:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.error,
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        else
                                          Container(
                                            width: double.infinity,
                                            height: 70,
                                            child: Center(
                                              child: Text(
                                                'Open a demo account to practice trading.',
                                                style:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Price Prediction',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                            ),
                                            const SizedBox(width: 4),
                                            Tooltip(
                                              message:
                                                  'Our AI-powered price prediction analyzes historical data and market trends to forecast the future stock price, helping you make smarter investment decisions.',
                                              child: const Icon(
                                                Icons.error_outline,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Date Prediction',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                            ),
                                            Text(
                                              '-',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.copyWith(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Price Prediction',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                            ),
                                            Text(
                                              '${detailStock?['ClosePriceTHB'] ?? '-'}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Related News',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 10),
                                            RecommentnewsStockdetail(
                                              news: newsRecommnet ?? [],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }
}

Widget _Loading() {
  return SizedBox(
    width: 200,
    child: LinearProgressIndicator(
      backgroundColor: Colors.blueAccent,
      color: Colors.white,
      minHeight: 6,
    ),
  );
}

class CandleData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class AveragePoint {
  final DateTime date;
  final double value;

  AveragePoint({required this.date, required this.value});
}
