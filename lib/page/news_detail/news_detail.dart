import 'package:flutter/material.dart';
import 'package:trademine/services/news_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatefulWidget {
  final int NewsID;
  const NewsDetail({super.key, required this.NewsID});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  Map<String, dynamic>? news;
  bool isLoading = true;

  Future<void> fetchNewsDetail() async {
    try {
      final detail = await AuthServiceNews.getNewsDetail(widget.NewsID);
      setState(() {
        news = detail;
        isLoading = false;
        print(news!['URL']);
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // เปิดในเบราว์เซอร์นอก
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ไม่สามารถเปิดลิงก์ได้')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNewsDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : news == null
              ? const Center(child: Text('ไม่พบข้อมูลข่าว'))
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 220,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            news?['ImageURL'] ??
                                'https://i.pinimg.com/736x/b2/a7/8b/b2a78b7520577fc3664213e22bffd2c3.jpg',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.07,
                            left: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                                iconSize: 30,
                                splashRadius: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news!['Title'] ?? 'No Title',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(news!['PublishedDate']))}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "| ${news!['ConfidenceScore']} confident",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(news!['Sentiment'] ?? ''),
                            backgroundColor: Colors.orangeAccent.shade100,
                            labelStyle: const TextStyle(color: Colors.white),
                            side: BorderSide.none,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                          const Divider(height: 32),
                          Text(
                            news!['Content'] ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 24),
                          Divider(color: Colors.grey.shade300),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Credit From: ${news!['Source']}  ',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey.shade600),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () => _openUrl(news!['URL']),
                                    child: Text(
                                      news!['Title'] ?? '',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: Colors.red.shade400,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
