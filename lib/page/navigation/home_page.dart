import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/credit_card/creditCardState.dart';
import 'package:trademine/bloc/home/HomepageCubit.dart';
import 'package:trademine/bloc/home/homepageState.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/search/search.dart';
import 'package:trademine/page/setting_card/create_card.dart';
import 'package:trademine/page/widget/recomment_stock.dart';
import 'package:trademine/page/widget/favorite_stocklist.dart';
import 'package:trademine/page/widget/recomment_news.dart';

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
  bool _isLoading = true;

  Future<void> _refreshHomePage() async {
    Future.microtask(() {
      context.read<HomePageCubit>().fetchData();
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshHomePage();
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
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        final stocks = state.favoriteStocks;
        final topStocks = state.topStocks;
        final lastestNews = state.latestNews;
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            edgeOffset: 20,
            onRefresh: () async {
              _refreshHomePage();
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
                    flexibleSpace: Container(
                      color: Theme.of(context).primaryColor,
                    ),
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
                                        : const AssetImage(
                                              'assets/defaultProfile.png',
                                            )
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
                              _refreshHomePage();
                            }
                          },
                          child: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.white,
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
                                  height: 135,
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
                                                symbol:
                                                    stock['StockSymbol'] ??
                                                    'N/A',
                                                name:
                                                    stock['StockSymbol'] ??
                                                    'N/A',
                                                price:
                                                    stock['ClosePrice'] ??
                                                    'N/A',
                                                change:
                                                    stock['ChangePercentage'] ??
                                                    'N/A',
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
                                minHeight:
                                    MediaQuery.of(context).size.height / 1.5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                                onTap: () async {
                                                  final changed =
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (_) =>
                                                                  SearchPage(),
                                                        ),
                                                      );
                                                  if (changed == true) {
                                                    _refreshHomePage();
                                                  }
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
                                          children: [
                                            Text('${stocks.length} List'),
                                          ],
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
                                                      (_, __) => const SizedBox(
                                                        height: 0,
                                                      ),
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
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
                                                      market:
                                                          stock['Market']!
                                                              .toString(),
                                                      onDelete: () {
                                                        setState(() {
                                                          stocks.removeAt(
                                                            index,
                                                          );
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
                                                      'Add Stock to Favorites',
                                                      style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium,
                                                    ),
                                                  )
                                                  : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isVisibleListView =
                                                            !_isVisibleListView;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 16,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.05),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          width: 1.2,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.05,
                                                                ),
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                            blurRadius: 4,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          FaIcon(
                                                            _isVisibleListView
                                                                ? FontAwesomeIcons
                                                                    .arrowUp
                                                                : FontAwesomeIcons
                                                                    .arrowDown,
                                                            size: 20,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            _isVisibleListView
                                                                ? 'Hide'
                                                                : 'Show',
                                                            style: Theme.of(
                                                                  context,
                                                                )
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                  color:
                                                                      Theme.of(
                                                                        context,
                                                                      ).colorScheme.primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              const SizedBox(height: 15),
                                              //Create New Account recomment
                                              BlocBuilder<
                                                CreditCardCubit,
                                                CreditCardState
                                              >(
                                                builder: (context, state) {
                                                  final CardsData =
                                                      state.cards ?? [];

                                                  if (CardsData.isEmpty) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .moneyCheck,
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              'Create an Account to Start Trading',
                                                              style:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .titleMedium,
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onTap:
                                                              () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (_) =>
                                                                          CreateCard(),
                                                                ),
                                                              ),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 15,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  50,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                              gradient: const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0xFF0F2027,
                                                                  ),
                                                                  Color(
                                                                    0xFF203A43,
                                                                  ),
                                                                  Color(
                                                                    0xFF2C5364,
                                                                  ),
                                                                ],
                                                                begin:
                                                                    Alignment
                                                                        .topLeft,
                                                                end:
                                                                    Alignment
                                                                        .bottomRight,
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                        0.25,
                                                                      ),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius:
                                                                      10,
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        5,
                                                                      ),
                                                                ),
                                                              ],
                                                              border: Border.all(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                width: 3,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 50,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 12,
                                                                  ),
                                                                  Text(
                                                                    "Create Account",
                                                                    style: Theme.of(
                                                                      context,
                                                                    ).textTheme.titleLarge?.copyWith(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  Text(
                                                                    "Start your investment journey",
                                                                    style: Theme.of(
                                                                          context,
                                                                        )
                                                                        .textTheme
                                                                        .bodyMedium
                                                                        ?.copyWith(
                                                                          color:
                                                                              Colors.white70,
                                                                        ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Lastest News',
                                                    style:
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.titleMedium,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                            NavigationCubit
                                                          >()
                                                          .goToPage(
                                                            1,
                                                          ); // เปลี่ยนไป TradePage
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .angleRight,
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
                                  if (lastestNews.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                            0.02,
                                      ),
                                      child: Row(
                                        children: [
                                          ...List.generate(lastestNews.length, (
                                            index,
                                          ) {
                                            final news = lastestNews[index];
                                            return RecommentNews(
                                              NewsId: news['NewsID'],
                                              title:
                                                  news['Title'] ?? 'No title',
                                              Img: news['Img'] ?? '',
                                              date: news['PublishedDate'] ?? '',
                                            );
                                          }),
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
      },
    );
  }
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
