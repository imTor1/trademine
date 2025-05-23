import 'package:flutter/material.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_password.dart';
import 'package:trademine/page/widget/RecommentStock_Home.dart';
import 'package:trademine/page/widget/favorite_stocklist.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/services/forgetpassword_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  bool _isVisibleListView = true;
  final textColor = const Color(0xff14213D);

  Future<void> fetchData(String userId) async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      print('Token ไม่พบ กรุณาเข้าสู่ระบบใหม่');
      return;
    }
    try {
      final profile = await AuthService.ProfileFecthData(userId, token);
      print(profile.runtimeType);
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  final List<Map<String, dynamic>> stocks = [
    {
      'symbol': 'AAPL',
      'name': 'Apple Inc.',
      'price': '180.50',
      'change': '+ 1.25%',
      'isPositive': true,
    },
    {
      'symbol': 'TSLA',
      'name': 'Tesla Inc.',
      'price': '650.75',
      'change': '- 2.10%',
      'isPositive': false,
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com',
      'price': '3300.00',
      'change': '+ 0.45%',
      'isPositive': true,
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com',
      'price': '3300.00',
      'change': '+ 0.45%',
      'isPositive': true,
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com',
      'price': '3300.00',
      'change': '+ 0.45%',
      'isPositive': true,
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com',
      'price': '3300.00',
      'change': '+ 0.45%',
      'isPositive': true,
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com',
      'price': '3300.00',
      'change': '+ 0.45%',
      'isPositive': true,
    },
  ];


  @override
  void initState() {
    super.initState();
    fetchData('123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: const Color(0xffFFCE47),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          setState(() {
            _currentIndex = 0;
          });
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: const Color(0xffFFCE47),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    'assets/avatar/man.png',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Color(0xff14213D).withOpacity(0.5),
                                    fontSize: 16,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff14213D).withOpacity(0.5),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 130,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: stocks.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(width: 15),
                          itemBuilder: (context, index) {
                            final stock = stocks[index];
                            return RecommentStockHome(
                              symbol: stock['symbol']!,
                              name: stock['name']!,
                              price: stock['price']!,
                              change: stock['change']!,
                              isPositive: stock['isPositive']!,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Favorite Stocks',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                          Container(
                            child: Column(
                              children: [
                                if (_isVisibleListView)
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: stocks.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                                    itemBuilder: (context, index) {
                                      final stock = stocks[index];
                                      return FavoriteStocklist(
                                        symbol: stock['symbol']!,
                                        name: stock['name']!,
                                        price: stock['price']!,
                                        change: stock['change']!,
                                        isPositive: stock['isPositive']!,
                                        onDelete: () {
                                          setState(() {
                                            stocks.removeAt(index);
                                          });
                                        },
                                      );
                                    },
                                  ),

                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isVisibleListView = !_isVisibleListView;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      _isVisibleListView ? 'Hide' : 'Show',
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
