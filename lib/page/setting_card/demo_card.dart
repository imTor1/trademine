import 'package:flutter/material.dart';
import 'package:trademine/page/widget/credit_card.dart';

class DemoCard extends StatefulWidget {
  const DemoCard({super.key});

  @override
  State<DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<DemoCard> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  late PageController _pageController;
  final List<String> currencies = ['USD', 'THB'];

  final List<Map<String, String>> cardData = [
    {'number': '20100 USD', 'name': 'John Doe', 'exp': '12/26'},
    {'number': '200 USD', 'name': 'Alice Smith', 'exp': '10/25'},
  ];

  List<Map<String, String>> _currentTransactionList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: _selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Text('Trade', style: Theme.of(context).textTheme.titleLarge),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
            ),
            pinned: false,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Demo Account',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 250,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: cardData.length,
                          itemBuilder: (context, index) {
                            final card = cardData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: CreditCard(
                                number: card['number'] ?? '',
                                name: card['name'] ?? '',
                                exp: card['exp'] ?? '',
                                isSelected: index == _selectedIndex,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
