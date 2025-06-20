import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return UserAccountsDrawerHeader(
      accountName: Text('John Doe'),
      accountEmail: Text('john.doe@example.com'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('lib/assets/images/avatar.png'),
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF973aa8) : Color(0xFF571089), // Darker background for dark mode
      ),
    );
  }
}
