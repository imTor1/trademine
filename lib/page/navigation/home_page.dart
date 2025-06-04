import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trademine/page/forgetpassword_page/forgetpassword_password.dart';
import 'package:trademine/page/widget/recomment_stock.dart';
import 'package:trademine/page/widget/favorite_stocklist.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/services/forgetpassword_service.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:trademine/utils/snackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;
  bool _isVisibleListView = true;

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
      print('Error: $e');
    }
  }

  final List<Map<String, dynamic>> stocks = [
    {
      'symbol': 'AAPL',
      'name': 'Apple Inc.',
      'price': '192.32',
      'change': '+1.75%',
      'isPositive': true,
    },
    {
      'symbol': 'TSLA',
      'name': 'Tesla Inc.',
      'price': '176.88',
      'change': '-0.92%',
      'isPositive': false,
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com Inc.',
      'price': '182.55',
      'change': '+2.10%',
      'isPositive': true,
    },
    {
      'symbol': 'GOOGL',
      'name': 'Alphabet Inc.',
      'price': '174.22',
      'change': '+0.87%',
      'isPositive': true,
    },
    {
      'symbol': 'MSFT',
      'name': 'Microsoft Corp.',
      'price': '421.15',
      'change': '-1.05%',
      'isPositive': false,
    },
    {
      'symbol': 'NVDA',
      'name': 'NVIDIA Corp.',
      'price': '1134.49',
      'change': '+3.84%',
      'isPositive': true,
    },
    {
      'symbol': 'META',
      'name': 'Meta Platforms Inc.',
      'price': '476.88',
      'change': '+0.55%',
      'isPositive': true,
    },
    {
      'symbol': 'NFLX',
      'name': 'Netflix Inc.',
      'price': '639.22',
      'change': '-0.48%',
      'isPositive': false,
    },
    {
      'symbol': 'AMD',
      'name': 'Advanced Micro Devices',
      'price': '166.77',
      'change': '+1.23%',
      'isPositive': true,
    },
    {
      'symbol': 'INTC',
      'name': 'Intel Corp.',
      'price': '30.15',
      'change': '-2.31%',
      'isPositive': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchData('123');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                          padding: EdgeInsets.only(
                            right: width * 0.05,
                            left: width * 0.05,
                            bottom: width * 0.03,
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
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: width * 0.06,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              GestureDetector(
                                onTap: () {
                                  AppSnackbar.showError(context, 'Search Page Open');
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: width * 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.02,
                                          ),
                                        ),
                                        Icon(Icons.search),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.02,
                                          ),
                                        ),
                                        Text('Search'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 140,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  itemCount: stocks.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(width: 10),
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
                            ),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: 3,
                              effect: WormEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                spacing: 10,
                                activeDotColor: Colors.white,
                                dotColor: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                        color: AppColor.textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ),

                                Row(children: [Text('${stocks.length} List')]),

                                const SizedBox(height: 5),
                                Container(
                                  child: Column(
                                    children: [
                                      if (_isVisibleListView)
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: stocks.length,
                                          separatorBuilder:
                                              (_, __) =>
                                                  const SizedBox(height: 0),
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
                                            _isVisibleListView =
                                                !_isVisibleListView;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            _isVisibleListView
                                                ? 'Hide detail'
                                                : 'Show detail',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Lastest News',
                                            style: TextStyle(
                                              color: AppColor.textColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            'Show more',
                                            style: TextStyle(
                                              color: AppColor.textColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(10, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Image
                                              Image.network(
                                                'https://www.shutterstock.com/image-illustration/tv-news-studio-broadcaster-breaking-260nw-1067935568.jpg',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 130,
                                              ),
                                              // Title
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      10,
                                                      8,
                                                      10,
                                                      4,
                                                    ),
                                                child: Text(
                                                  'US Tariffs Expected To Dent Thai GDP',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff14213D),
                                                  ),
                                                ),
                                              ),
                                              // Date and Time Ago
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      10,
                                                      0,
                                                      10,
                                                      10,
                                                    ),
                                                child: Text(
                                                  'Date: 2/4/2025 | 2d',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
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
      ),
    );
  }
}
