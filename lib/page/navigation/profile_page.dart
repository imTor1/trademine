import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trademine/bloc/credit_card/CreditCardCubit.dart';
import 'package:trademine/bloc/credit_card/HoldingStockCubit.dart';
import 'package:trademine/bloc/notification/notificationCubit.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/navigation/navigation_bar.dart';
import 'package:trademine/page/setting/edit_profile.dart';
import 'package:trademine/page/setting/setting_page.dart';
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
  DateTime? _selectedDate;

  Future<void> Logout() async {
    try {
      final storage = FlutterSecureStorage();
      await context.read<UserCubit>().clearUser();
      await storage.deleteAll();
      context.read<NotificationCubit>().deleteAllNotifications();
      context.read<CreditCardCubit>().deleteAllCards();
      await context.read<HoldingStocksCubit>().ResetHoldingStocks();
      context.read<NavigationCubit>().goToPage(0);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      AppSnackbar.showError(
        context,
        e.toString(),
        Icons.error,
        Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserCubit>().state;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: false,
        title: Text(
          'Profile',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: theme.primaryColor,
                ),
                // ส่วนเมนูสีขาว
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      top: 60,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            (user.name?.isNotEmpty ?? false)
                                ? user.name!
                                : 'xxxxxx',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            (user.email?.isNotEmpty ?? false)
                                ? user.email!
                                : 'xxxxxxxx',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 20),
                          _buildMenuItem(
                            icon: FontAwesomeIcons.clockRotateLeft,
                            title: 'History',
                            onTap: () {},
                          ),
                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 15,
                          ),
                          _buildMenuItem(
                            icon: FontAwesomeIcons.newspaper,
                            title: 'Liked News',
                            onTap: () {},
                          ),
                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 15,
                          ),
                          _buildMenuItem(
                            icon: FontAwesomeIcons.gear,
                            title: 'Setting',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SettingPage(),
                                ),
                              );
                            },
                          ),

                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 15,
                          ),
                          _buildMenuItem(
                            icon: FontAwesomeIcons.arrowRightFromBracket,
                            title: 'Logout',
                            onTap: () {
                              Logout();
                            },
                          ),
                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: screenWidth / 2 - 65,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      user.profileImage?.isNotEmpty ?? false
                          ? NetworkImage(user.profileImage!)
                          : const AssetImage('assets/avatar/man.png')
                              as ImageProvider,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: Icon(icon, color: iconColor ?? Colors.black),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(FontAwesomeIcons.angleRight, size: 16),
      onTap: onTap,
    );
  }
}
