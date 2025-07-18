import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/loading_page/TransactionHistoryShimmer.dart';
import 'package:trademine/page/navigation/news_page.dart';
import 'package:trademine/page/search/search.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/page/widget/recomment_stock.dart';
import 'package:trademine/page/widget/favorite_stocklist.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/services/constants/api_constants.dart';
import 'package:trademine/page/widget/recomment_news.dart';
import 'package:trademine/services/news_service.dart';
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
  bool _isExpandedFavorite = false;
  bool isLoading = true;

  var username;
  var image;
  var stocks = [];
  var topStocks = [];
  var lastestNews = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'auth_token');
      final String? userId = await storage.read(key: 'user_Id');

      if (token == null || userId == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
        return;
      }
      final favoriteStock = await AuthServiceUser.ShowFavoriteStock(token);
      final profile = await AuthServiceUser.ProfileFecthData(userId, token);
      final topStock = await AuthServiceStock.RecommentStock();
      final lastest_news = await AuthServiceNews.LatestNews(
        limit: 10,
        offset: 0,
      );
      setState(() {
        isLoading = !isLoading;
        lastestNews = lastest_news['news'];
        stocks = favoriteStock ?? [];
        topStocks = topStock ?? [];
        image = ApiConstants.baseUrl + (profile['profileImage'] ?? '');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        edgeOffset: 20,
        onRefresh: () async {
          setState(() {
            isLoading = !isLoading;
          });
          await fetchData();
        },
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            overscroll: false,
            physics: const ClampingScrollPhysics(),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 60,
                centerTitle: false,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(color: Theme.of(context).primaryColor),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                (user.profileImage?.isNotEmpty ?? false)
                                    ? NetworkImage(user.profileImage!)
                                    : const AssetImage('assets/avatar/man.png')
                                        as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              (user.name?.isNotEmpty ?? false)
                                  ? user.name!
                                  : '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final search_page = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ),
                        );
                        if (search_page == true) {
                          fetchData();
                        }
                      },
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                floating: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          if (topStocks.isNotEmpty)
                            SizedBox(
                              height: 150,
                              child: AnimationLimiter(
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                  ),
                                  itemCount: topStocks.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final stock = topStocks[index];
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      child: SlideAnimation(
                                        horizontalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: RecommentStock(
                                            symbol: stock['StockSymbol']!,
                                            name: stock['StockSymbol']!,
                                            price: stock['ClosePrice']!,
                                            change: stock['ChangePercentage']!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      const SizedBox(height: 5),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
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
                                  top: 13,
                                  left: width * 0.05,
                                  right: width * 0.05,
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
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        if (stocks.isEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => SearchPage(),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.add,
                                              size: 30,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).iconTheme.color,
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
                                          Visibility(
                                            visible: _isVisibleListView,
                                            child: ListView.separated(
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
                                                  symbol:
                                                      stock['StockSymbol']!
                                                          .toString(),
                                                  name:
                                                      stock['CompanyName']!
                                                          .toString(),
                                                  price:
                                                      stock['LastPrice']!
                                                          .toString(),
                                                  change:
                                                      stock['LastChange']!
                                                          .toString(),
                                                  onDelete: () {
                                                    setState(() {
                                                      stocks.removeAt(index);
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          stocks.isEmpty
                                              ? Center(
                                                child: Text(
                                                  'Add stock to your favorites',
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium,
                                                ),
                                              )
                                              : GestureDetector(
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
                                                    style:
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (lastestNews.isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  child: Row(
                                    children: [
                                      ...List.generate(lastestNews.length, (
                                        index,
                                      ) {
                                        final news = lastestNews[index];
                                        return RecommentNews(
                                          NewsId: news['NewsID'],
                                          title: news['Title'] ?? 'No title',
                                          Img: news['Img'] ?? '',
                                          date: news['PublishedDate'] ?? '',
                                        );
                                      }),
                                      _buildSeeMoreCard(context),
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSeeMoreCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => NewsPage()));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Container(
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward, size: 32, color: Colors.grey),
                SizedBox(height: 8),
                Text('See More', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class RecommentStockShimmer extends StatelessWidget {
  const RecommentStockShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row avatar + symbol
            Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 80, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(height: 10, width: 120, color: Colors.white),
                    ],
                  ),
                ),
                Container(height: 24, width: 48, color: Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 12, width: 100, color: Colors.white),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 16, width: 60, color: Colors.white),
                Container(height: 16, width: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
