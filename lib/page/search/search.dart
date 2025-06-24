import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trademine/page/loading_page/search_shimmer.dart';
import 'package:trademine/page/widget/search_stock.dart';
import 'package:trademine/services/search.service.dart';

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

  @override
  void initState() {
    super.initState();
    search.addListener(_onSearchChanged);
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
      if (search.text.trim().isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        try {
          final results = await AuthServiceSearch.searchStocks(
            search.text.trim(),
          );
          await Future.delayed(const Duration(milliseconds: 700));
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                          contentPadding: EdgeInsets.symmetric(
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
                          itemCount: 15,
                          itemBuilder: (_, __) => ShimmerSearchStock(),
                        )
                        : searchResults.isEmpty
                        ? const Center(child: Text('No results'))
                        : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final stock = searchResults[index];
                            return SearchStock(
                              symbol: stock['StockSymbol']!.toString(),
                              name: stock['CompanyName']!.toString(),
                              price: stock['ClosePrice']!.toString(),
                              change: stock['ClosePrice']!.toString(),
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
