import 'package:flutter/material.dart';

class PredictionCard extends StatelessWidget {
  final String datePrediction;
  final String pricePrediction;
  final Color priceColor;

  const PredictionCard({
    super.key,
    required this.datePrediction,
    required this.pricePrediction,
    this.priceColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date Prediction',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  datePrediction,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: priceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price Prediction',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  pricePrediction,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
