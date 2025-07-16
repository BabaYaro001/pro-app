import 'package:flutter/material.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';
import 'developer_info_screen.dart';
import 'notifications_screen.dart';

class DrawerMenu extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  const DrawerMenu({super.key, required this.userName, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
            ),
            accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("School Member"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/logo.png', width: 48, height: 48),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.rule),
            title: const Text('Terms of Service'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Developer Info'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DeveloperInfoScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}