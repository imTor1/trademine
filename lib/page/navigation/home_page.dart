import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/widget/recomment_stock.dart';
import 'package:trademine/page/widget/favorite_stocklist.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/services/constants/api_constants.dart';
import 'package:trademine/page/widget/recomment_news.dart';
import 'package:trademine/services/user_service.dart';
import 'package:trademine/services/forgetpassword_service.dart';

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
  var username;
  var image;

  Future<void> fetchData() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'auth_token');
    final String? userId = await storage.read(key: 'user_Id');

    if (token == null || userId == null) {
      print('Token or UserID not found');
      return;
    }

    try {
      print("User ID: $userId");
      print("Token: $token");

      final favoriteStock = await AuthServiceUser.ShowFavoriteStock(token);
      final profile = await AuthServiceUser.ProfileFecthData(userId, token);
      for (var stock in favoriteStock) {
        print("Favorite Stock: ${stock['StockSymbol']}");
      }
      setState(() {
        image = ApiConstants.baseUrl + profile['profileImage'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final List<Map<String, dynamic>> stocks = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: RefreshIndicator(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                  color: Theme.of(context).primaryColor,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      '${image.toString()}',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    (user.name?.isNotEmpty ?? false)
                                        ? user.name
                                        : 'null',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              GestureDetector(
                                onTap: () {
                                  AppSnackbar.showError(
                                    context,
                                    'Search Page Open',
                                  );
                                },
                                child: Container(
                                  height: 45,
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
                                        Icon(
                                          Icons.search,
                                          color: AppColor.textColor.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.02,
                                          ),
                                        ),
                                        Text(
                                          'Search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.textColor
                                                .withOpacity(0.5),
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
                        Column(
                          children: [
                            SizedBox(
                              height: 140,
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
                            const SizedBox(height: 15),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: stocks.length,
                              effect: WormEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                spacing: 10,
                                activeDotColor: Colors.white,
                                dotColor: Color(0xff606060),
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
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Favorite Stocks',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.add,
                                        size: 30,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(children: [Text('${stocks.length} List')]),
                                const SizedBox(height: 10),
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
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                          Text(
                                            'Show more',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 0),
                            itemBuilder: (context, index) {
                              return RecommentNews();
                            },
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
