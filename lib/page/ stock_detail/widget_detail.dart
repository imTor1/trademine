import 'package:flutter/material.dart';

class WidgetDetail extends StatelessWidget {
  final List<String> title;
  final List<String> data;

  const WidgetDetail({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(title.length, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: i == title.length - 1 ? 0 : 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title[i],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      data[i],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 20),
        Container(width: 1, height: 70, color: Colors.grey),
      ],
    );
  }
}
