import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase Storage support
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// Screens and Notifiers
import 'screens/splash_screen.dart';
import 'screens/theme_notifier.dart';
import 'screens/user_profile.dart';
import 'screens/drawer_item.dart';
import 'screens/profile_screen.dart';
import 'screens/mood_tracker.dart';
import 'screens/sketch_scribble.dart';
import 'screens/meditation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    print("Firebase initialization failed: $e\n$stack");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: themeNotifier.getTheme(),
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/mood-tracker': (context) => const MoodTrackerPage(),
        '/MoodTrackerPage': (context) => const MoodTrackerPage(),
        '/sketch-scribble': (context) => const SketchApp(),
        '/SketchApp': (context) => const SketchApp(),
        '/meditation': (context) => const MentalHealthMusicApp(),
        '/MentalHealthMusicApp': (context) => const MentalHealthMusicApp(),
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const UserProfile(),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  DrawerItem(
                    icon: Icons.edit,
                    text: 'Edit Profile',
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                  DrawerItem(
                    icon: Icons.home,
                    text: 'Dashboard',
                    onTap: () => Navigator.pushNamed(context, '/home'),
                  ),
                  DrawerItem(
                    icon: Icons.mood,
                    text: 'Mood Tracker',
                    onTap: () => Navigator.pushNamed(context, '/MoodTrackerPage'),
                  ),
                  DrawerItem(
                    icon: Icons.brush,
                    text: 'Sketch Scribble',
                    onTap: () => Navigator.pushNamed(context, '/SketchApp'),
                  ),
                  DrawerItem(
                    icon: Icons.self_improvement,
                    text: 'Meditation',
                    onTap: () => Navigator.pushNamed(context, '/MentalHealthMusicApp'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Consumer<ThemeNotifier>(
              builder: (context, theme, _) => ListTile(
                leading: Icon(theme.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
                title: const Text('Toggle Theme'),
                trailing: Switch(
                  value: theme.isDarkMode,
                  onChanged: (value) => theme.toggleTheme(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await AuthService().signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out")),
                );
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

class UploadHelper {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        final UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);
        final TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
        return null;
      }
    }
    return null;
  }

  static Future<String?> uploadAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      final File audioFile = File(result.files.single.path!);
      final String fileName = 'audio/${DateTime.now().millisecondsSinceEpoch}.mp3';

      try {
        final UploadTask uploadTask = _storage.ref(fileName).putFile(audioFile);
        final TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading audio: $e");
        return null;
      }
    }
    return null;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToScreen(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Quick Access Section
            const Text(
              'Quick Access',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                // Profile Quick Access
                _QuickAccessButton(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () => _navigateToScreen(context, '/profile'),
                ),
                // Home Quick Access
                _QuickAccessButton(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () => _navigateToScreen(context, '/home'),
                ),
                // Mood Tracker Quick Access
                _QuickAccessButton(
                  icon: Icons.mood,
                  label: 'Mood',
                  onTap: () => _navigateToScreen(context, '/mood-tracker'),
                ),
                // Sketch Scribble Quick Access
                _QuickAccessButton(
                  icon: Icons.brush,
                  label: 'Sketch',
                  onTap: () => _navigateToScreen(context, '/sketch-scribble'),
                ),
                // Meditation Quick Access
                _QuickAccessButton(
                  icon: Icons.self_improvement,
                  label: 'Meditate',
                  onTap: () => _navigateToScreen(context, '/meditation'),
                ),
                // Theme Toggle Quick Access
                Consumer<ThemeNotifier>(
                  builder: (context, theme, _) => _QuickAccessButton(
                    icon: theme.isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                    label: 'Theme',
                    onTap: () => theme.toggleTheme(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Original Upload Buttons
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Upload Image"),
              onPressed: () async {
                final url = await UploadHelper.uploadImage();
                if (url != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Image uploaded: $url")),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.audiotrack),
              label: const Text("Upload Audio"),
              onPressed: () async {
                final url = await UploadHelper.uploadAudio();
                if (url != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Audio uploaded: $url")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}