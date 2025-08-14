import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page.dart';
import 'news_page.dart';
import 'trade_page.dart';
import 'activity_page.dart';
import 'profile_page.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void goToPage(int index) => emit(index);
}

// -------------------- NavigationBarPage --------------------
class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _pages = [
    const HomePage(),
    const NewsPage(),
    const TradePage(),
    const ActivityPage(),
    const ProfilePage(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': 'assets/navbar_icon/home.png',
      'activeIcon': 'assets/navbar_icon/home.png',
      'label': 'Home',
    },
    {
      'icon': 'assets/navbar_icon/news.png',
      'activeIcon': 'assets/navbar_icon/news.png',
      'label': 'News',
    },
    {
      'icon': 'assets/navbar_icon/trade.png',
      'activeIcon': 'assets/navbar_icon/trade.png',
      'label': 'Trade',
    },
    {
      'icon': 'assets/navbar_icon/activity.png',
      'activeIcon': 'assets/navbar_icon/activity.png',
      'label': 'Activity',
    },
    {
      'icon': 'assets/navbar_icon/me.png',
      'activeIcon': 'assets/navbar_icon/me.png',
      'label': 'Me',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: IndexedStack(index: selectedIndex, children: _pages),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 4,
                        child: Row(
                          children: List.generate(_navItems.length, (index) {
                            return Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                color:
                                    selectedIndex == index
                                        ? Theme.of(context)
                                            .bottomNavigationBarTheme
                                            .selectedItemColor
                                        : Colors.transparent,
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(_navItems.length, (
                                index,
                              ) {
                                final item = _navItems[index];
                                final isSelected = selectedIndex == index;
                                return Expanded(
                                  child: InkWell(
                                    onTap:
                                        () => context
                                            .read<NavigationCubit>()
                                            .goToPage(index),
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            isSelected
                                                ? item['activeIcon']
                                                : item['icon'],
                                            width: 24,
                                            height: 24,
                                            color:
                                                isSelected
                                                    ? Theme.of(context)
                                                        .bottomNavigationBarTheme
                                                        .selectedItemColor
                                                    : Theme.of(context)
                                                        .bottomNavigationBarTheme
                                                        .unselectedItemColor,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['label'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color:
                                                  isSelected
                                                      ? Theme.of(context)
                                                          .bottomNavigationBarTheme
                                                          .selectedItemColor
                                                      : Theme.of(context)
                                                          .bottomNavigationBarTheme
                                                          .unselectedItemColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ElevatedButton(
//   onPressed: () {
//     context.read<NavigationCubit>().goToPage(2); // เปลี่ยนไป TradePage
//   },
//   child: const Text('Go to TradePage'),
// );
