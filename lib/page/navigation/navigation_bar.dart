import 'package:flutter/material.dart';
import 'package:trademine/page/navigation/activity_page.dart';
import 'package:trademine/page/navigation/home_page.dart';
import 'package:trademine/page/navigation/news_page.dart';
import 'package:trademine/page/navigation/profile_page.dart';
import 'package:trademine/page/navigation/trade_page.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'dart:ui';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBarPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  final _pages = [
    HomePage(),
    NewsPage(),
    TradePage(),
    ActivityPage(),
    ProfilePage(),
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

  void _navigateToPage(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _controller.reset();
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
                                _selectedIndex == index
                                    ? Theme.of(
                                      context,
                                    ).bottomNavigationBarTheme.selectedItemColor
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
                          children: List.generate(_navItems.length, (index) {
                            final item = _navItems[index];
                            final isSelected = _selectedIndex == index;
                            return Expanded(
                              child: InkWell(
                                onTap: () => _navigateToPage(index),
                                customBorder: const CircleBorder(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
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
                                        ],
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
  }
}
