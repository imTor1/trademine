import 'package:flutter/material.dart';
import 'package:trademine/theme/app_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03),
                    child: Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(''),
                          ),
                          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02)),
                          Text(
                            'Name',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                          Text(
                            'test@gmail.com',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('History Page');
                            },
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.history, size: 30),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                            ),
                                            Text(
                                              'History',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              print('History Page');
                            },
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.link, size: 30),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                            ),
                                            Text(
                                              'Link',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              print('History Page');
                            },
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.settings, size: 30),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                            ),
                                            Text(
                                              'Setting',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              print('History Page');
                            },
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.logout, size: 30),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                            ),
                                            Text(
                                              'Logout',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
