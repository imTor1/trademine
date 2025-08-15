import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trademine/page/setting/edit_profile.dart';
import 'package:trademine/theme/app_styles.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:trademine/utils/snackbar.dart';

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
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Setting', style: theme.textTheme.titleLarge),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text('User Settings', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 15),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.solidUser,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfile()),
                      );
                    },
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 15),
                  const SizedBox(height: 20),
                  Text('App Settings', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 15),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.lock,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 15),
                  Material(
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: (Theme.of(context).colorScheme.primary)
                                    .withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FontAwesomeIcons.solidBell,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Notification',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Switch(
                              value: _isNotificationOn,
                              onChanged: (bool value) {
                                setState(() {
                                  _isNotificationOn = value;
                                  if (value == true) {
                                    AppSnackbar.showError(
                                      context,
                                      'Notification : ON',
                                      FontAwesomeIcons.solidBell,
                                      Theme.of(context).colorScheme.secondary,
                                    );
                                  } else {
                                    AppSnackbar.showError(
                                      context,
                                      'Notification : OFF',
                                      FontAwesomeIcons.solidBell,
                                      Theme.of(context).colorScheme.error,
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Divider(color: Theme.of(context).dividerColor, height: 15),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.earthAsia,
                    title: 'Language',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 15),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.headset,
                    title: 'Support',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 15),
                  _buildMenuItem(
                    icon: FontAwesomeIcons.info,
                    title: 'About',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 15),
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
    Color? backgroundColor,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? cs.primary).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor ?? Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(FontAwesomeIcons.angleRight, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
