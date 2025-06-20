import 'package:flutter/material.dart';
import 'question_page.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mood Tracker", style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFFD9EDF6),
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuestionPage(questionIndex: 0, selectedAnswers: [])),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF89B4E6),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: const Text("Start Mood Tracker", style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
