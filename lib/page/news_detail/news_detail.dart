import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  double _textScale = 1.0;

  Future<void> fetchNewsDetail() async {
    try {
      final detail = await AuthServiceNews.getNewsDetail(widget.NewsID);
      if (!mounted) return;
      setState(() {
        news = detail;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading news detail: ${e.toString()}')),
      );
    }
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid link available to open!')),
      );
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot open the link!')));
    }
  }

  Future<void> _copyUrl(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copied to clipboard')));
  }

  Color _getSentimentColor(String? sentiment) {
    if (sentiment == null) return Colors.grey;
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Theme.of(context).colorScheme.secondary;
      case 'negative':
        return Theme.of(context).colorScheme.error;
      case 'neutral':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _getHost(String? url) {
    if (url == null || url.isEmpty) return '';
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return '';
    }
  }

  int _estimateReadingMinutes(String? content) {
    if (content == null || content.isEmpty) return 1;
    final words = content.trim().split(RegExp(r'\s+')).length;
    return (words / 200).ceil().clamp(1, 60);
  }

  void _showTextSizeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Text size', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('A-'),
                  Expanded(
                    child: Slider(
                      value: _textScale,
                      min: 0.85,
                      max: 1.4,
                      divisions: 11,
                      onChanged: (v) => setState(() => _textScale = v),
                    ),
                  ),
                  const Text('A+'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchNewsDetail();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = news?['ImageURL'] as String?;
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : news == null
              ? const Center(child: Text('Not Found News'))
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
                    expandedHeight: 200,
                    floating: true,
                    snap: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: [
                      if ((news?['URL'] ?? '').toString().isNotEmpty)
                        IconButton(
                          tooltip: 'Open source',
                          icon: const Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                          ),
                          onPressed: () => _openUrl(news!['URL']),
                        ),
                      if ((news?['URL'] ?? '').toString().isNotEmpty)
                        IconButton(
                          tooltip: 'Copy link',
                          icon: const Icon(Icons.link, color: Colors.white),
                          onPressed: () => _copyUrl(news!['URL']),
                        ),
                      IconButton(
                        tooltip: 'Text size',
                        icon: const Icon(
                          Icons.text_increase,
                          color: Colors.white,
                        ),
                        onPressed: _showTextSizeSheet,
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (imageUrl != null && imageUrl.trim().isNotEmpty)
                            Image.network(
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
                                        loadingProgress.expectedTotalBytes !=
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
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          else
                            Container(
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "| ${news!['ConfidenceScore']} confident",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '| ~${_estimateReadingMinutes(news?['Content'])} min read',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text(news!['Sentiment'] ?? ''),
                                backgroundColor: _getSentimentColor(
                                  news?['Sentiment'],
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
                                label: Text(news!['Source']),
                                backgroundColor: Theme.of(context).primaryColor,
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
                          SelectableText(
                            news!['Content'] ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(height: 1.6),
                            textScaleFactor: _textScale,
                          ),
                          const SizedBox(height: 24),
                          Divider(color: Colors.grey.shade300),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Credit From: ${news!['Source']}  ',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey.shade600),
                                ),
                                WidgetSpan(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _openUrl(news!['URL']),
                                      child: Text(
                                        news!['Title'] ?? '',
                                        style: TextStyle(
                                          color: Colors.red.shade400,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if ((news?['URL'] ?? '').toString().isNotEmpty)
                                  TextSpan(
                                    text: '  (${_getHost(news?['URL'])})',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
