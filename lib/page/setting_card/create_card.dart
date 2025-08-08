import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/page/loading_page/loading_circle.dart';
import 'package:trademine/page/widget/credit_card/credit_card.dart';
import 'package:trademine/services/portfolio.dart';
import 'package:trademine/utils/snackbar.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({super.key});

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  final TextEditingController _balance = TextEditingController();

  bool _isLoading = false;
  int _selectedIndex = 0;
  late PageController _pageController;

  Future<void> CreateNewCard() async {
    setState(() {
      _isLoading = !_isLoading;
    });

    try {
      final storage = await FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      final data = await AuthServicePortfolio.CreditDemo(token!, _balance.text);
      context.read<CreditCardCubit>().fetchCards();

      Navigator.pop(context);
    } catch (e) {
      AppSnackbar.showError(
        context,
        '$e',
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

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
    _balance.dispose();
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
              'Crete New Card',
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
                      final card = {
                        'typeCard': 'Demo',
                        'number': 'XXX',
                        'name': 'xxx',
                        'exp': 'XX/XX',
                      };
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
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        controller: _balance,
                        decoration: InputDecoration(
                          hintText: 'Balance',
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                          prefixIcon: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Theme.of(context).hintColor,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).dividerColor,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          CreateNewCard();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
