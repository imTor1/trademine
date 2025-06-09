import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/signin_page/login.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/utils/snackbar.dart';
import 'package:trademine/page/widget/menu_item.dart';
import 'package:bloc/bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> Logout() async {
    try {
      final storage = FlutterSecureStorage();
      await storage.delete(key: 'auth_token');
      context.read<UserCubit>().clearUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      AppSnackbar.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    return Scaffold(
      backgroundColor: AppColor.primaryColor2,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Text(
                        'Profile',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(color: AppColor.primaryColor2),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.only(top: 80),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.15,
                              right: MediaQuery.of(context).size.width * 0.15,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  (user.name?.isNotEmpty ?? false)
                                      ? user.name!
                                      : 'null',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  (user.email?.isNotEmpty ?? false)
                                      ? user.email!
                                      : 'null',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Column(
                                children: [
                                  MenuItem(
                                    context: context,
                                    icon: Icons.history,
                                    text: 'History',
                                    onTap: () => print('History'),
                                  ),
                                  Divider(
                                    color: AppColor.backgroundColor,
                                    height: 15,
                                  ),
                                  MenuItem(
                                    context: context,
                                    icon: Icons.newspaper,
                                    text: 'Liked News',
                                    onTap: () => print('Liked News'),
                                  ),
                                  Divider(
                                    color: AppColor.backgroundColor,
                                    height: 15,
                                  ),
                                  MenuItem(
                                    context: context,
                                    icon: Icons.settings,
                                    text: 'Setting',
                                    onTap: () => print('Setting'),
                                  ),
                                  Divider(
                                    color: AppColor.backgroundColor,
                                    height: 15,
                                  ),
                                  MenuItem(
                                    context: context,
                                    icon: Icons.logout,
                                    text: 'Logout',
                                    onTap: Logout,
                                  ),
                                  Divider(
                                    color: AppColor.backgroundColor,
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment(0, -0.8),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5.0),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/e1/47/38/e147388d4132ca17413f55a5c72590d7.jpg',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
