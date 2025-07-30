import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import 'package:trademine/page/loading_page/TransactionHistoryShimmer.dart';
import 'package:trademine/page/setting_card/card_config.dart';
import 'package:trademine/page/widget/credit_card.dart';
import 'package:trademine/page/widget/transaction_history.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  late PageController _pageController;
  final List<String> currencies = ['USD', 'THB'];
  String _selectedCurrency = 'USD';

  final List<Map<String, String>> _transactionDemo1 = [
    {
      'title': 'NVD',
      'fullname': 'Nvidia Corporation',
      'price': '1000',
      'date': '2025-11-10',
    },
    {
      'title': 'MSFT',
      'fullname': 'Microsoft Corp.',
      'price': '450',
      'date': '2025-11-09',
    },
  ];

  final List<Map<String, String>> _transactionDemo2 = [
    {
      'title': 'TSLA',
      'fullname': 'Tesla Inc.',
      'price': '850',
      'date': '2025-11-08',
    },
    {
      'title': 'GOOG',
      'fullname': 'Alphabet Inc.',
      'price': '1500',
      'date': '2025-11-07',
    },
    {
      'title': 'AMZN',
      'fullname': 'Amazon.com Inc.',
      'price': '180',
      'date': '2025-11-06',
    },
  ];

  List<Map<String, String>> _currentTransactionList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.95,
      initialPage: _selectedIndex,
    );
    _loadTransactions(_selectedIndex);
  }

  Future<void> _loadTransactions(int index) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      if (index == 0) {
        _currentTransactionList = _transactionDemo1;
      } else if (index == 1) {
        _currentTransactionList = _transactionDemo2;
      } else {
        _currentTransactionList = [];
      }
      _isLoading = false;
    });
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
        final CardsData = state.cards;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: false,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Trade',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Assets (${CardsData.length})',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              DropdownButton<String>(
                                value: _selectedCurrency,
                                icon: const Icon(Icons.arrow_drop_down),
                                style: Theme.of(context).textTheme.titleSmall,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCurrency = newValue!;
                                  });
                                },
                                items:
                                    currencies.map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: CardsData.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                          _loadTransactions(index);
                        },
                        itemBuilder: (context, index) {
                          final card = CardsData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 400),
                                child: CreditCardWidget(
                                  typeCard: card['typeCard'] ?? '',
                                  number: card['number'] ?? '',
                                  name: card['name'] ?? '',
                                  exp: card['exp'] ?? '',
                                  isSelected: index == _selectedIndex,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        final labels = ['Buy', 'Sell', 'More', 'Add'];
                        final icons = [
                          Icons.upload,
                          Icons.download,
                          Icons.more_horiz,
                          Icons.add,
                        ];
                        final color = [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.error,
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary,
                        ];
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                switch (index) {
                                  case 0:
                                    print('Buy button pressed!');
                                    break;
                                  case 1:
                                    print('Sell button pressed!');
                                    break;
                                  case 2:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => DemoCard(
                                              CardData: [
                                                CardsData[_selectedIndex],
                                              ],
                                            ),
                                      ),
                                    );
                                    break;
                                  case 3:
                                    print('Add button pressed!');
                                    break;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(18),
                                backgroundColor: color[index],
                              ),
                              child: Icon(
                                icons[index],
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            if (labels[index].isNotEmpty)
                              const SizedBox(height: 6),
                            if (labels[index].isNotEmpty)
                              Text(
                                labels[index],
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return const TransactionHistoryShimmer();
                      },
                      childCount: 10, // จำนวน shimmer item ที่ต้องการแสดง
                    ),
                  )
                  : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final history = _currentTransactionList[index];
                      return TransactionHistory(
                        symbol: history['title'].toString(),
                        name: history['fullname'].toString(),
                        price: history['price'].toString(),
                        date: history['date'].toString(),
                      );
                    }, childCount: _currentTransactionList.length),
                  ),
            ],
          ),
        );
      },
    );
  }
}
