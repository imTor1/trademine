import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trademine/page/%20stock_detail/widget_detail.dart';
import 'package:trademine/services/stock_service.dart';
import 'package:intl/intl.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/utils/snackbar.dart';

class StockDetail extends StatefulWidget {
  final String StockSymbol;
  const StockDetail({super.key, required this.StockSymbol});

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  bool follow = false;
  Map<String, dynamic>? detailStock;
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  List<CandleData> chartData = [];
  String selectedTimeframe = "5D";

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
                style: const TextStyle(color: Colors.white),
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
      AppSnackbar.showError(context, 'Error checking followed stock: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final data = await AuthServiceStock.StockDetail(
        widget.StockSymbol,
        timeframe: selectedTimeframe,
      );
      setState(() {
        detailStock = data;
        chartData = convertToCandleData(detailStock!);
      });
    } catch (e) {
      print('Error fetching data: $e');
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

  @override
  Widget build(BuildContext context) {
    final List<List<String>> allTitles = [
      ['Open', 'High', 'Low'],
      ['Vol', 'P/E', 'Mkt Cap'],
      ['Market', 'Sector', 'Industry'],
    ];

    final List<List<String>> allData = [
      ['24.50', '25.30', '23.80'],
      ['1.5M', '120B', '15.2'],
      ['1.5M', '120B', '15.2'],
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:
          detailStock == null
              ? Center(child: Loading())
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
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      detailStock?['StockSymbol'] ?? 'No Stock',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: Icon(
                          follow ? Icons.favorite_sharp : Icons.favorite_border,
                          color:
                              follow
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        onPressed: () async {
                          AppSnackbar.showError(
                            context,
                            'This stock is already in your favorites.',
                          );
                        },
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height / 1.5,
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
                                  MediaQuery.of(context).size.width * 0.04,
                              vertical:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            detailStock?['StockSymbol'] ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(fontSize: 24),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(detailStock?['Type'] ?? ''),
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
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  detailStock?['company'] ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Price: ${detailStock?['ClosePrice'] ?? '-'} (${detailStock?['ClosePriceTHB'] ?? '-'}) THB',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Date: ${detailStock?['Date'] ?? '-'}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child:
                                detailStock?['HistoricalPrices'] == null
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : Padding(
                                      padding: EdgeInsets.zero,
                                      child: SfCartesianChart(
                                        margin: EdgeInsets.zero,
                                        plotAreaBorderWidth: 0,
                                        primaryXAxis: DateTimeAxis(
                                          majorGridLines: const MajorGridLines(
                                            width: 0,
                                          ),
                                          dateFormat: DateFormat('d MMM, yyyy'),
                                          edgeLabelPlacement:
                                              EdgeLabelPlacement.shift,
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(
                                            width: 0,
                                          ),
                                          opposedPosition: true,
                                          labelAlignment: LabelAlignment.end,
                                          numberFormat: NumberFormat('#,###'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 10,
                                          ),
                                        ),
                                        trackballBehavior: _trackballBehavior,
                                        zoomPanBehavior: _zoomPanBehavior,
                                        enableAxisAnimation: false,
                                        series: <CartesianSeries>[
                                          SplineAreaSeries<
                                            CandleData,
                                            DateTime
                                          >(
                                            dataSource: chartData,
                                            xValueMapper:
                                                (CandleData data, _) =>
                                                    data.date,
                                            yValueMapper:
                                                (CandleData data, _) =>
                                                    data.close,
                                            splineType: SplineType.natural,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.15),
                                            borderColor: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.7),
                                            borderWidth: 2.5,
                                            animationDuration: 0,
                                            markerSettings:
                                                const MarkerSettings(
                                                  isVisible: false,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),

                          const SizedBox(height: 20),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: timeframeLabels.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final key = timeframeLabels.keys.elementAt(
                                  index,
                                );
                                final label = timeframeLabels[key];
                                final isSelected = key == selectedTimeframe;

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
                                              return Colors.white.withOpacity(
                                                0.2,
                                              );
                                            }
                                            return isSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent;
                                          }),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                            isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                          ),
                                      shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          side: BorderSide.none,
                                        ),
                                      ),
                                      elevation:
                                          MaterialStateProperty.all<double>(0),
                                    ),
                                    onPressed: () {
                                      if (selectedTimeframe != key) {
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
                                  MediaQuery.of(context).size.width * 0.04,
                              vertical:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        allTitles.length,
                                        (index) {
                                          return Row(
                                            children: [
                                              WidgetDetail(
                                                title: allTitles[index],
                                                data: allData[index],
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
                                  const SizedBox(height: 15),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Date Prediction',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        'BUY',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      Text(
                                        'Related News',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
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
  }
}

Widget Loading() {
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
