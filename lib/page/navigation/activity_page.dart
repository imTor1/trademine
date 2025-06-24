import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            centerTitle: false,
            leadingWidth: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Text(
                  'Notification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
