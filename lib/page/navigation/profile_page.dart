import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trademine/bloc/user_cubit.dart';
import 'package:trademine/page/setting/edit_profile.dart';
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
      context.read<UserCubit>().clearUser();
      await storage.deleteAll();
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
                // แถบสีบน ความสูง 100
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
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            (user.email?.isNotEmpty ?? false)
                                ? user.email!
                                : 'xxxxxxxx',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          MenuItem(
                            context: context,
                            icon: Icons.history,
                            text: 'History',
                            onTap: () => print('History'),
                          ),
                          Divider(color: AppColor.backgroundColor, height: 15),
                          MenuItem(
                            context: context,
                            icon: Icons.newspaper,
                            text: 'Liked News',
                            onTap: () => print('Liked News'),
                          ),
                          Divider(color: AppColor.backgroundColor, height: 15),
                          MenuItem(
                            context: context,
                            icon: Icons.settings,
                            text: 'Setting',
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfile(),
                                  ),
                                ),
                          ),
                          Divider(color: AppColor.backgroundColor, height: 15),
                          MenuItem(
                            context: context,
                            icon: Icons.logout,
                            text: 'Logout',
                            onTap: Logout,
                          ),
                          Divider(color: AppColor.backgroundColor, height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Avatar ลอยกลางบน (ตำแหน่ง fixed)
            Positioned(
              top: 20,
              left: screenWidth / 2 - 65, // กึ่งกลางจอ - ครึ่งความกว้าง avatar
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
}
