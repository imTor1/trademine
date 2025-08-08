import 'package:flutter/material.dart';
import 'package:trademine/page/widget/credit_card/credit_card.dart';

class DemoCard extends StatefulWidget {
  final List<Map<String, dynamic>>? CardData;
  const DemoCard({super.key, required this.CardData});

  @override
  State<DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<DemoCard> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.95,
      initialPage: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Text(
              widget.CardData != null && widget.CardData!.isNotEmpty
                  ? '${widget.CardData![0]['typeCard'].toString().toUpperCase()} ACCOUNT'
                  : '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                            'Credit Card',
                            style: Theme.of(context).textTheme.titleMedium,
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
                    itemCount: 1,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final card = widget.CardData?[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CreditCardWidget(
                          typeCard: card?['typeCard'] ?? '',
                          number: card?['number'] ?? '',
                          name: card?['name'] ?? '',
                          exp: card?['exp'] ?? '',
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
    );
  }
}
