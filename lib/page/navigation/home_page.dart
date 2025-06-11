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
import 'package:trademine/services/stock_service.dart';

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
  var stocks = [];
  var topStocks = [];

  Future<void> fetchData() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      final String? userId = await storage.read(key: 'user_Id');

      if (token == null || userId == null) {
        print('Token or UserID not found');
        return;
      }

      final favoriteStock = await AuthServiceUser.ShowFavoriteStock(token);
      final profile = await AuthServiceUser.ProfileFecthData(userId, token);
      final topStock = await AuthServiceStock.TopStock();
      setState(() {
        stocks = favoriteStock;
        topStocks = topStock;
        image = ApiConstants.baseUrl + profile['profileImage'];
      });
      print(stocks);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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
    final user = context
        .watch<UserCubit>()
        .state;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      body: RefreshIndicator(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        backgroundColor: const Color(0xffFFCE47),
        onRefresh: () async {
          fetchData();
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Theme
                      .of(context)
                      .primaryColor,
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
                                      fontSize: 22,
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
                                itemCount: topStocks.length,
                                separatorBuilder:
                                    (context, index) =>
                                const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final stock = topStocks[index];
                                  return RecommentStock(
                                    symbol: stock['StockSymbol']!,
                                    name: stock['StockSymbol']!,
                                    price: stock['ClosePrice']!,
                                    change: stock['ChangePercentage']!,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: topStocks.length,
                              effect: WormEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                spacing: 10,
                                activeDotColor: Colors.white,
                                dotColor: Color(0xff606060),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight:
                            MediaQuery
                                .of(context)
                                .size
                                .height -
                                (MediaQuery
                                    .of(context)
                                    .padding
                                    .top +
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height / 3),
                          ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Favorite Stocks',
                                          style:
                                          Theme
                                              .of(
                                            context,
                                          )
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.add,
                                            size: 30,
                                            color:
                                            Theme
                                                .of(
                                              context,
                                            )
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [Text('${stocks.length} List')],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      child: Column(
                                        children: [
                                          if (_isVisibleListView)
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: stocks.length,
                                              separatorBuilder:
                                                  (_, __) =>
                                              const SizedBox(height: 0),
                                              itemBuilder: (context, index) {
                                                final stock = stocks[index];
                                                return FavoriteStocklist(
                                                  symbol: stock['StockSymbol']!,
                                                  name: stock['StockSymbol']!,
                                                  price: stock['LastPrice']!,
                                                  change: stock['LastChange']!,
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
                                                Theme
                                                    .of(
                                                  context,
                                                )
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Text(
                                                'Show more',
                                                style:
                                                Theme
                                                    .of(
                                                  context,
                                                )
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
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
