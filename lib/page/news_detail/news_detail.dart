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
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? news;
  bool isLoading = true;

  Future<void> fetchNewsDetail() async {
    try {
      final detail = await AuthServiceNews.getNewsDetail(widget.NewsID);
      setState(() {
        news = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading news detail: ${e.toString()}')),
        );
      }
    }
  }

  void _openUrl(String? url) async {
    if (url == null || url.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No valid link available to open!')),
        );
      }
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cannot open the link!')));
      }
    }
  }

  Color _getSentimentColor(String? sentiment) {
    if (sentiment == null) return Colors.grey;
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      case 'neutral':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNewsDetail();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = news?['ImageURL'];
    return Stack(
      children: [
        Scaffold(
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : news == null
                  ? const Center(child: Text('Not Fourd News'))
                  : CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'Back',
                        ),
                        automaticallyImplyLeading: false,
                        expandedHeight: 250,
                        pinned: false,
                        floating: true,
                        snap: true,
                        backgroundColor: Theme.of(context).primaryColor,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  )
                                  : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                    stops: const [0.0, 0.6, 1.0],
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
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(news!['PublishedDate']))}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "| ${news!['ConfidenceScore']} confident",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(news!['Sentiment'] ?? ''),
                                    backgroundColor: _getSentimentColor(
                                      news?['Sentiment']?.toString(),
                                    ),
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
                                    side: BorderSide.none,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),

                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const SizedBox(width: 10),
                                  Chip(
                                    label: Text('TH Stock'),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
                                    side: BorderSide.none,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                              const Divider(height: 35),
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
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
                                            decoration:
                                                TextDecoration.underline,
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
        ),
      ],
    );
  }
}
