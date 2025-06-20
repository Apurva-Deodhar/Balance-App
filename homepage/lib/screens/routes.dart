// routes.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'threee_sense.dart';
import 'sketch_scribble.dart';
import 'remember_me.dart';
import 'meditation.dart';
import 'gratitude_journalling.dart';
import 'mood_tracker.dart';
import 'breathing.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomeScreen(),
  '/profile': (context) => ProfileScreen(),
  '/three-sense': (context) => ThreeSensesGame(),
  '/scribble': (context) => SketchApp(),
  '/remember': (context) => RememberItGame(),
  '/meditation': (context) => MentalHealthMusicApp(),
  '/gratitude': (context) => GratitudeJournalingPage(),
  '/mood-tracker': (context) => MoodTrackerPage(),
  '/breathing': (context) => BreathingTechniquesPage(),
};


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'), // Change this to your profile image path
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Implement logout logic here
              Navigator.pop(context);
            },
          ),
          Divider(), // Separator
          // Dark and Light Theme Toggle
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Dark / Light Theme'),
            onTap: () {
              // Implement theme change logic
            },
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default Light Theme
      darkTheme: ThemeData.dark(), // Dark Theme
      themeMode: ThemeMode.system, // Follows system theme
      routes: routes,
      home: HomeScreen(),
    );
  }
}

void main() {
  runApp(MyApp());
}
