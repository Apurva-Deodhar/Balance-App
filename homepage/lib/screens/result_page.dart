import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import your HomeScreen file

class ResultPage extends StatelessWidget {
  final List<int?> selectedAnswers;

  const ResultPage({super.key, required this.selectedAnswers});

  String _getMoodMessage(int totalScore) {
    if (totalScore >= 12) {
      return "Happy & Energized 🎉";
    } else if (totalScore >= 8) {
      return "Calm & Neutral 🙂";
    } else if (totalScore >= 4) {
      return "Tired or Slightly Down 😴";
    } else {
      return "Stressed or Upset 😞";
    }
  }

  String _getMoodImage(int totalScore) {
    if (totalScore >= 12) {
      return "assets/happy.gif";
    } else if (totalScore >= 8) {
      return "assets/neutral.gif";
    } else if (totalScore >= 4) {
      return "assets/angry.gif";
    } else {
      return "assets/sad.gif";
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = selectedAnswers.fold(0, (sum, score) => sum + (score ?? 0));
    const Color darkBlue = Color(0xFF89B4E6);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Mood"),
        backgroundColor: const Color(0xFFD9EDF6),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getMoodMessage(totalScore),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              _getMoodImage(totalScore),
              width: 200,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chatbot Screen")),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
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
