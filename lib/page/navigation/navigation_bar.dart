import 'package:flutter/material.dart';
import 'package:trademine/page/navigation/activity_page.dart';
import 'package:trademine/page/navigation/home_page.dart';
import 'package:trademine/page/navigation/news_page.dart';
import 'package:trademine/page/navigation/profile_page.dart';
import 'package:trademine/page/navigation/trade_page.dart';
import 'package:trademine/page/signin_page/login.dart';

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
      'icon': 'assets/home.png',
      'activeIcon': 'assets/home.png',
      'label': 'Home',
    },
    {
      'icon': 'assets/trademine_mini.png',
      'activeIcon': 'assets/trademine_mini.png',
      'label': 'News',
    },
    {
      'icon': 'assets/trademine_mini.png',
      'activeIcon': 'assets/trademine_mini.png',
      'label': 'Trade',
    },
    {
      'icon': 'assets/trademine_mini.png',
      'activeIcon': 'assets/trademine_mini.png',
      'label': 'Activity',
    },
    {
      'icon': 'assets/trademine_mini.png',
      'activeIcon': 'assets/trademine_mini.png',
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
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Color(0xffFCA311);
    final secondaryColor = Color(0xffAAAAAA);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;

                return Expanded(
                  child: InkWell(
                    onTap: () => _navigateToPage(index),
                    customBorder: const CircleBorder(),
                    splashColor: primaryColor.withOpacity(0.1),
                    highlightColor: primaryColor.withOpacity(0.05),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                isSelected ? item['activeIcon'] : item['icon'],
                                width: 24,
                                height: 24,
                                color:
                                    isSelected ? primaryColor : secondaryColor,
                              ),
                              if (isSelected)
                                FadeTransition(
                                  opacity: _animation,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color: isSelected ? primaryColor : secondaryColor,
                            ),
                          ),
                          if (isSelected)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              width: 20,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
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
    );
  }
}
