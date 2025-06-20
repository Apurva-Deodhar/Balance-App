import 'package:flutter/material.dart';
import 'threee_sense.dart';
import 'sketch_scribble.dart';
import 'remember_me.dart';
import 'meditation.dart';
import 'gratitude_journalling.dart';
import 'mood_tracker.dart';
import 'breathing.dart';
import 'profile_screen.dart';
import 'chatbot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lightBlue = const Color(0xFFE0F7FA);
    final mediumBlue = const Color(0xFFF8FCFD);
    final darkBlue = const Color(0xFF82B0E6);

    return Scaffold(
      backgroundColor: const Color(0xFFD9EDF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Balance',
          style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dailyQuote(darkBlue),
                const SizedBox(height: 20),
                _sectionTitle("Quick Access"),
                _quickAccessRow(context),
                const SizedBox(height: 20),
                _buildBox(
                  context,
                  "Mood Tracker",
                  mediumBlue,
                  Icons.mood,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoodTrackerPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _sectionTitle("Calm & Focus"),
                _calmFocusRow(context),
                const SizedBox(height: 20),
                _buildBox(
                  context,
                  "Gratitude Journal",
                  mediumBlue,
                  Icons.book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GratitudeJournalingPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _sectionTitle("Mindful Games"),
                _mindfulGamesRow(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatbotScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
      ),
    );
  }

  Widget _dailyQuote(Color color) {
    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "\"Peace comes from within. Do not seek it without.\"",
            style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("- Buddha", style: TextStyle(fontSize: 14, color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _quickAccessRow(BuildContext context) {
    return SizedBox(
      height: 100,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double boxWidth = (constraints.maxWidth - 24) / 3;
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _iconBox(context, Icons.mood_rounded, "Mood Tracker", boxWidth, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoodTrackerPage()),
                );
              }),
              _iconBox(context, Icons.brush_sharp, "Sketch & Scribble", boxWidth, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SketchApp()),
                );
              }),
              _iconBox(context, Icons.multitrack_audio_sharp, "Meditation", boxWidth, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MentalHealthMusicApp()),
                );
              }),
              _iconBox(context, Icons.book, "Gratitude Journal", boxWidth, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GratitudeJournalingPage()),
                );
              }),
              _iconBox(context, Icons.music_note_outlined, "Calming Music", boxWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _calmFocusRow(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3 - 24;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconBox(context, Icons.music_note, "Calming Music", width, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MentalHealthMusicApp()));
        }),
        _iconBox(context, Icons.self_improvement, "Breathing Techniques", width, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BreathingTechniquesPage()));
        }),
        _iconBox(context, Icons.headphones, "Guided Meditation", width, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MentalHealthMusicApp()));
        }),
      ],
    );
  }

  Widget _mindfulGamesRow(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3 - 24;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconBox(context, Icons.gamepad, "Three-sense", width, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ThreeSensesGame()));
        }),
        _iconBox(context, Icons.brush_sharp, "Scribble", width, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SketchApp()));
        }),
        _iconBox(context, Icons.memory, "Remember It", width, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RememberItGame()));
        }),
      ],
    );
  }

  Widget _iconBox(BuildContext context, IconData icon, String label, double width,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label Tapped')));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, String title, Color color, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title Clicked')));
      },
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}