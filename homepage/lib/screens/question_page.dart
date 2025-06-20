import 'package:flutter/material.dart';
import 'result_page.dart';

class QuestionPage extends StatefulWidget {
  final int questionIndex;
  final List<int?> selectedAnswers;

  const QuestionPage({super.key, required this.questionIndex, required this.selectedAnswers});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final List<Map<String, dynamic>> questions = [
    {
      "question": "How are you feeling right now?",
      "options": ["Happy and excited", "Calm and neutral", "A bit tired or bored", "Stressed or upset"],
      "scores": [3, 2, 1, 0]
    },
    {
      "question": "What kind of music do you feel like listening to?",
      "options": ["Upbeat and energetic", "Chill and relaxing", "Something slow and emotional", "I don’t feel like listening to music"],
      "scores": [3, 2, 1, 0]
    },
    {
      "question": "How would you describe your energy level?",
      "options": ["Full of energy, ready to do things", "Normal, just going with the flow", "A bit low, feeling sluggish", "Drained, no motivation"],
      "scores": [3, 2, 1, 0]
    },
    {
      "question": "How do you feel about socializing right now?",
      "options": ["I’d love to talk and be around people", "I don’t mind a small chat", "I prefer being alone for now", "I want to avoid people completely"],
      "scores": [3, 2, 1, 0]
    },
    {
      "question": "What best describes your thoughts at the moment?",
      "options": ["Positive and hopeful", "Neutral, just going through the day", "A bit worried or overthinking", "Negative and overwhelmed"],
      "scores": [3, 2, 1, 0]
    },
  ];

  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[widget.questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${widget.questionIndex + 1} of 5"),
        backgroundColor: const Color(0xFFD9EDF6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display options
            Column(
              children: List.generate(4, (index) {
                return RadioListTile<int>(
                  title: Text(currentQuestion['options'][index]),
                  value: currentQuestion['scores'][index],
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                );
              }),
            ),

            const Spacer(),

            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedOption == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select an answer")),
                    );
                    return;
                  }

                  List<int?> newAnswers = List.from(widget.selectedAnswers)..add(selectedOption);

                  if (widget.questionIndex < questions.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(
                          questionIndex: widget.questionIndex + 1,
                          selectedAnswers: newAnswers,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(selectedAnswers: newAnswers),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF89B4E6),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
