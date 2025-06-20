import 'package:flutter/material.dart';
import 'package:homepage/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homepage/screens/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  String _selectedImage = 'assets/images/avatar.png'; // Default

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> profileImages = [
    'assets/dog.png',
    'assets/crocodile.png',
    'assets/elephant.png',
    'assets/giraffe.png',
    'assets/panda.png',
    'assets/penguin.png',
  ];

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    _nameController.text = _user!.displayName ?? '';
    _emailController.text = _user!.email ?? '';

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? _user!.displayName ?? '';
      _emailController.text = data['email'] ?? _user!.email ?? '';
      setState(() {
        _selectedImage = data['avatar'] ?? _selectedImage;
      });
    }
  }

  Future<void> _saveUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .set({
      'name': _nameController.text,
      'email': _emailController.text,
      'avatar': _selectedImage,
    });
  }

  void _selectProfilePicture(String image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhotoUrl = _user?.photoURL != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFFD9EDF6),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: hasPhotoUrl
                      ? NetworkImage(_user!.photoURL!)
                      : AssetImage(_selectedImage) as ImageProvider,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: profileImages.map((image) {
                    return GestureDetector(
                      onTap: () => _selectProfilePicture(image),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(image),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                _isEditing
                    ? ElevatedButton(
                        onPressed: () async {
                          await _saveUserData();
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text("Save"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: const Text("Edit"),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home, size: 30, color: Colors.blueAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, size: 30, color: Colors.redAccent),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        final GoogleSignIn googleSignIn = GoogleSignIn();
                        if (await googleSignIn.isSignedIn()) {
                          await googleSignIn.signOut();
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
