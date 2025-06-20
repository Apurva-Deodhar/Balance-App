import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homepage/screens/home_screen.dart';
import 'gratitude_entries_page.dart';

class GratitudeJournalingPage extends StatefulWidget {
  const GratitudeJournalingPage({super.key});

  @override
  State<GratitudeJournalingPage> createState() => _GratitudeJournalingPageState();
}

class _GratitudeJournalingPageState extends State<GratitudeJournalingPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 1;

  void _submitGratitude() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      final now = DateTime.now();

      final entry = {
        "date": "${now.month}/${now.day}/${now.year}",
        "time": "${now.hour}:${now.minute.toString().padLeft(2, '0')}",
        "entry": text,
      };

      try {
        await _firestore
            .collection("gratitude_entries")
            .doc(user.uid)
            .collection("entries")
            .add(entry);

        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved: $text")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _viewEntries() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GratitudeEntriesPage(), // updated to fetch from Firestore
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chatbot Screen")));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gratitude Journaling", style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFFD9EDF6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Write what you are grateful for today!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 7,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: "Start writing here...",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _submitGratitude,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF89B4E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _viewEntries,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF89B4E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: const Text("View Entries", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF89B4E6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: const Center(child: Text("Dashboard Screen")),
    );
  }
}
