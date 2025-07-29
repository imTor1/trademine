import 'package:flutter/material.dart';
import '../../utils/snackbar.dart';
import '../loading_page/news_shimmer.dart';
import '../news_detail/news_detail.dart';

class RecommentnewsStockdetail extends StatelessWidget {
  final List<dynamic> news;

  const RecommentnewsStockdetail({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return Center(child: Text('No News Available'));
    }

    return Column(
      children: news.map<Widget>((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                    child: item['Img'] != null && item['Img'].toString().isNotEmpty
                        ? Image.network(
                      item['Img'],
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported_sharp),
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
      }).toList(),
    );
  }
}
