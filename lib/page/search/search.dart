import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trademine/page/loading_page/search_shimmer.dart';
import 'package:trademine/page/widget/search_stock.dart';
import 'package:trademine/services/search.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController search = TextEditingController();
  Timer? _debounce;
  bool isLoading = false;
  List<dynamic> searchResults = [];
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    search.addListener(_onSearchChanged);
    _loadSearchHistory();
  }

  @override
  void dispose() {
    search.removeListener(_onSearchChanged);
    search.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final query = search.text.trim();
      if (query.isNotEmpty) {
        setState(() => isLoading = true);
        try {
          final results = await AuthServiceSearch.searchStocks(query);
          await _saveSearchKeyword(query);

          setState(() {
            searchResults = results['results'];
            isLoading = false;
          });
        } catch (e) {
          setState(() {
            searchResults = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          searchResults = [];
          isLoading = false;
        });
      }
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_keywords') ?? [];
    if (mounted) {
      setState(() {
        searchHistory = history;
      });
    }
  }

  Future<void> _saveSearchKeyword(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_keywords') ?? [];

    history.remove(keyword);
    history.insert(0, keyword);

    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await prefs.setStringList('search_keywords', history);
    _loadSearchHistory();
  }

  Future<void> _deleteKeyword(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_keywords') ?? [];

    history.remove(keyword);
    await prefs.setStringList('search_keywords', history);
    _loadSearchHistory();
  }

  Future<void> _clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_keywords');
    _loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: search,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).dividerColor,
                          filled: true,
                          hintText: 'Search',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).disabledColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    isLoading
                        ? ListView.builder(
                          itemCount: 10,
                          itemBuilder: (_, __) => ShimmerSearchStock(),
                        )
                        : search.text.trim().isEmpty
                        ? searchHistory.isEmpty
                            ? const Center(child: Text('No search history'))
                            : ListView.builder(
                              itemCount: searchHistory.length,
                              itemBuilder: (context, index) {
                                final keyword = searchHistory[index];
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  constraints: const BoxConstraints(
                                    minHeight: 40,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.history,
                                        size: 22,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => search.text = keyword,
                                          child: Text(
                                            keyword,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onBackground,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.clear, size: 20),
                                        color: Colors.grey[600],
                                        onPressed:
                                            () => _deleteKeyword(keyword),
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                        : searchResults.isEmpty
                        ? const Center(child: Text('No results'))
                        : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final stock = searchResults[index];
                            return SearchStock(
                              symbol: stock['StockSymbol']?.toString() ?? '',
                              name: stock['CompanyName']?.toString() ?? '',
                              price: stock['ClosePrice']?.toString() ?? '',
                              change: stock['ChangePercen']?.toString() ?? '',
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
