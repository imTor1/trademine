import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trademine/theme/app_styles.dart';

class TransactionHistoryShimmer extends StatelessWidget {
  const TransactionHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Icon(Icons.circle, color: Colors.grey, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: width * 0.2, height: 14),
                      const SizedBox(height: 4),
                      ShimmerBox(width: width * 0.3, height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerBox(width: width * 0.2, height: 14),
                    const SizedBox(height: 4),
                    ShimmerBox(width: width * 0.25, height: 12),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: AppColor.divider),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
