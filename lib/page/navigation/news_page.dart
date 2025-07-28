import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:trademine/page/loading_page/news_shimmer.dart';
import 'package:trademine/page/news_detail/news_detail.dart';
import 'package:trademine/services/news_service.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/page/widget/filternews.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String selectedCategory = 'all';
  List<dynamic> newsList = [];
  bool isLoading = false;
  bool hasMore = true;
  bool isFetchingMore = false;
  int offset = 0;
  final int limit = 30;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  bool showScrollToTopButton = false;

  //Filter_Option
  var sortOptions = 'DESC';
  var selectedSentiment = '';

  @override
  void initState() {
    super.initState();
    fetchInitialNews();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_scrollListenerForButton);
  }

  void _scrollListenerForButton() {
    if (_scrollController.offset > 300 && !showScrollToTopButton) {
      setState(() => showScrollToTopButton = true);
    } else if (_scrollController.offset <= 300 && showScrollToTopButton) {
      setState(() => showScrollToTopButton = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isFetchingMore && hasMore && !_isScrolling) {
        _isScrolling = true;
        fetchMoreNews().then((_) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _isScrolling = false;
          });
        });
      }
    }
  }

  Future<void> fetchInitialNews() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      newsList.clear();
      offset = 0;
      hasMore = true;
    });

    try {
      final result = await AuthServiceNews.LatestNews(
        limit: limit,
        offset: offset,
        source: selectedCategory ?? 'all',
        sortOptions: sortOptions,
        selectedSentiment: selectedSentiment,
      );
      await Future.delayed(const Duration(seconds: 1));
      final fetchedNews = result['news'];
      if (mounted) {
        setState(() {
          newsList = List.from(fetchedNews);
          offset += limit;
          hasMore = fetchedNews.length == limit;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Loading News Error: ${e.toString()}',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
        setState(() {
          hasMore = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchMoreNews() async {
    if (isFetchingMore || !hasMore) return;

    setState(() {
      isFetchingMore = true;
    });

    try {
      final result = await AuthServiceNews.LatestNews(
        limit: limit,
        offset: offset,
        source: selectedCategory ?? 'all',
        selectedSentiment: selectedSentiment,
      );

      await Future.delayed(const Duration(seconds: 1));
      final fetchedNews = result['news'];

      if (mounted) {
        setState(() {
          if (fetchedNews.isNotEmpty) {
            newsList.addAll(fetchedNews);
            offset += limit;
            hasMore = fetchedNews.length == limit;
          } else {
            hasMore = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          'Loading News Error: ${e.toString()}',
          Icons.error,
          Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isFetchingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            edgeOffset: 20,
            onRefresh: fetchInitialNews,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 60,
                  centerTitle: false,
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'Today News',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SliverToBoxAdapter(child: _buildCategoryChips()),
                _buildNewsList(newsList),
                if (isFetchingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (!hasMore && newsList.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No More News',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (showScrollToTopButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              mini: true,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          ...['all', 'TH News', 'US News'].map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                  category == 'all'
                      ? 'All'
                      : category[0].toUpperCase() + category.substring(1),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        selectedCategory == category
                            ? Colors.white
                            : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                selected: selectedCategory == category,
                onSelected: (_) {
                  setState(() {
                    selectedCategory = category;
                  });
                  fetchInitialNews();
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color:
                        selectedCategory == category
                            ? Colors.transparent
                            : const Color(0xff14213D),
                    width: 1,
                  ),
                ),
                showCheckmark: false,
                elevation: 2,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, String>>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder:
                    (context) => FilterNews(
                      initialSort: sortOptions,
                      initialSentiment: selectedSentiment,
                    ),
              );
              if (result != null) {
                setState(() {
                  sortOptions = result['sortOptions'] ?? sortOptions;
                  selectedSentiment =
                      result['selectedSentiment'] ?? selectedSentiment;
                });

                fetchInitialNews();
              }
            },
          ),
        ],
      ),
    );
  }
  Widget _buildNewsList(List<dynamic> news) {
    if (isLoading && news.isEmpty) {
      return const SliverFillRemaining(child: NewsShimmer());
    }
    if (news.isEmpty && !isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No More News',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: fetchInitialNews,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = news[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (item['NewsID'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewsDetail(NewsID: item['NewsID']),
                  ),
                );
              } else {
                AppSnackbar.showError(
                  context,
                  'News ID is missing',
                  Icons.error,
                  Theme.of(context).colorScheme.error,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        item['Img'] != null && item['Img'].toString().isNotEmpty
                            ? Image.network(
                              item['Img'],
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported_sharp,
                                    ),
                                  ),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 100,
                              height: 100,
                              color: Colors.white,
                            ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['Title'] ?? 'No Title',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['Sentiment'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                            Text(
                              item['PublishedDate'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[700]),
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
        );
      }, childCount: news.length),
    );
  }
}
