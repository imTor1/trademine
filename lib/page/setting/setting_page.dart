import 'package:flutter/material.dart';
import 'package:trademine/page/setting/edit_profile.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:another_flushbar/flushbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Setting', style: theme.textTheme.titleMedium),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text('User Settings', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfile()),
                      );
                    },
                  ),
                  Divider(color: AppColor.backgroundColor, height: 15),
                  const SizedBox(height: 20),
                  Text('App Settings', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    icon: Icons.lock,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  Divider(color: AppColor.backgroundColor, height: 15),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(Icons.notifications, color: Colors.black),
                    title: Text(
                      'Notification',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: _isNotificationOn,
                        onChanged: (bool value) {
                          setState(() {
                            _isNotificationOn = value;
                            if (value == true) {
                              Flushbar(
                                message: "Notification : ON",
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.black87,
                                flushbarPosition:
                                    FlushbarPosition.TOP, // หรือ .BOTTOM
                                borderRadius: BorderRadius.circular(8),
                                margin: const EdgeInsets.all(16),
                              ).show(context);
                            } else {
                              Flushbar(
                                message: "Notification : OFF",
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.black87,
                                flushbarPosition:
                                    FlushbarPosition.TOP, // หรือ .BOTTOM
                                borderRadius: BorderRadius.circular(8),
                                margin: const EdgeInsets.all(16),
                              ).show(context);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Divider(color: AppColor.backgroundColor, height: 15),
                  _buildMenuItem(
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {},
                  ),
                  Divider(color: AppColor.backgroundColor, height: 15),
                  _buildMenuItem(
                    icon: Icons.support_agent,
                    title: 'Support',
                    onTap: () {},
                  ),
                  Divider(color: AppColor.backgroundColor, height: 15),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {},
                  ),
                  Divider(color: AppColor.backgroundColor, height: 15),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
