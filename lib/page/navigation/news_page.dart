import 'package:flutter/material.dart';
import 'package:trademine/page/loading_page/search_shimmer.dart';
import 'package:trademine/page/news_detail/news_detail.dart';
import 'package:trademine/services/news_service.dart';
import 'package:trademine/utils/snackbar.dart';

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

  @override
  void initState() {
    super.initState();
    fetchInitialNews();
    _scrollController.addListener(_onScroll);
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
        AppSnackbar.showError(context, 'Loading News Error: ${e.toString()}');
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
        AppSnackbar.showError(context, 'Loding News Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          isFetchingMore = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await fetchInitialNews();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNews = _getFilteredNews();

    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 20,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 60,
              centerTitle: false,
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  Text(
                    'Today News',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            _buildNewsList(filteredNews),
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
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _getFilteredNews() {
    if (selectedCategory == 'all') {
      return newsList;
    }
    return newsList.where((n) => n['Sentiment'] == selectedCategory).toList();
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          ...[
            'all',
            'TH News',
            'US News',
            'Neutral',
            'Positive',
            'Negative',
          ].map(
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
                  setState(() => selectedCategory = category);
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
        ],
      ),
    );
  }

  Widget _buildNewsList(List<dynamic> filteredNews) {
    if (isLoading && newsList.isEmpty) {
      return const SliverFillRemaining(child: ShimmerSearchStock());
    }

    if (newsList.isEmpty && !isLoading) {
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
        final item = filteredNews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewsDetail(NewsID: item['NewsID']),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['Title'] ?? 'No Title',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['Sentiment'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        item['PublishedDate'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }, childCount: filteredNews.length),
    );
  }
}
