import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'user_profile.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // User Profile at the top
            const UserProfile(),

            const Divider(),

            // Expanded scrollable content
            Expanded(
              child: ListView(
                children: [
                  DrawerItem(
                    icon: Icons.edit,
                    text: 'Edit Profile',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.home,
                    text: 'Dashboard',
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            // Theme toggle
            Consumer<ThemeNotifier>(
              builder: (context, theme, _) => ListTile(
                leading: Icon(theme.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
                title: const Text('Toggle Theme'),
                trailing: Switch(
                  value: theme.isDarkMode,
                  onChanged: (value) {
                    theme.toggleTheme();
                  },
                ),
              ),
            ),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Add logout logic here
                Navigator.pop(context);
                // You can add your logout functionality here
                // For example: AuthService.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}