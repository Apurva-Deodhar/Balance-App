import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homepage/screens/home_screen.dart';

class GratitudeEntriesPage extends StatefulWidget {
  const GratitudeEntriesPage({super.key});

  @override
  _GratitudeEntriesPageState createState() => _GratitudeEntriesPageState();
}

class _GratitudeEntriesPageState extends State<GratitudeEntriesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _entries = []; // ✅ Fixed type
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadUserEntries();
  }

  Future<void> _loadUserEntries() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('gratitude_entries')
        .doc(user.uid)
        .collection('entries')
        .orderBy('date', descending: true)
        .get();

    setState(() {
      _entries = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "date": data['date'] ?? '',
          "time": data['time'] ?? '',
          "entry": data['entry'] ?? '',
        };
      }).toList();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chatbot Screen")),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dashboard Screen")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Your Gratitude Entries", style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFFD9EDF6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text("No entries yet!", style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  color: const Color(0xFFD9EDF6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Entry ${index + 1}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Date: ${entry["date"]}",
                            style: const TextStyle(fontSize: 14)),
                        Text("Time: ${entry["time"]}",
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                        Text("Entry: ${entry["entry"]}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
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
