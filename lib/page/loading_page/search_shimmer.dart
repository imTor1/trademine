import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSearchStock extends StatelessWidget {
  const ShimmerSearchStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star_border, size: 25),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 100, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 150, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(height: 12, width: 60, color: Colors.white),
                const SizedBox(height: 6),
                Container(height: 12, width: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
