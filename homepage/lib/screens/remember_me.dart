import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:homepage/screens/home_screen.dart';

void main() => runApp(RememberItGame());

class RememberItGame extends StatelessWidget {
  const RememberItGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remember It',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: InstructionScreen(),
    );
  }
}

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _bgGradient(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom Back Button without AppBar
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 40.0), // Adjust padding as needed
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black54),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                  ),
                ),

                Image.asset(
                  'assets/word1.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Remember It ',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint('You will be shown 10 random 3-letter words.'),
                        _buildBulletPoint('You have 60 seconds to memorize them.'),
                        _buildBulletPoint('Try to recall and type them all correctly.'),
                        _buildBulletPoint('Challenge your brain and improve memory!'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: _btnStyle(),
                  child: Text('Start Game',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  onPressed: () {
                    List<String> words = _generateRandomWords(10);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MemorizeScreen(words: words)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  List<String> _generateRandomWords(int count) {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return List.generate(count, (_) {
      return String.fromCharCodes(Iterable.generate(
          3, (_) => letters.codeUnitAt(random.nextInt(letters.length))));
    });
  }




  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          Expanded(
            child: Text(text,
                style: TextStyle(color: Colors.white70, fontSize: 16)),
          )
        ],
      ),
    );
  }



class MemorizeScreen extends StatefulWidget {
  final List<String> words;
  const MemorizeScreen({super.key, required this.words});

  @override
  _MemorizeScreenState createState() => _MemorizeScreenState();
}

class _MemorizeScreenState extends State<MemorizeScreen> {
  int seconds = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          _timer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => InputScreen(correctWords: widget.words),
            ),
          );
        }

      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _bgGradient(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Memorize the words ⏱️',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 10),
                Text(
                  '$seconds seconds',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3,
                  children: widget.words
                      .map((word) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      word,
                      style:
                      TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputScreen extends StatelessWidget {
  final List<String> correctWords;

  InputScreen({super.key, required this.correctWords});

  final List<TextEditingController> controllers =
  List.generate(10, (_) => TextEditingController());

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // important
      body: Container(
        decoration: _bgGradient(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Type the 10 words you remember ✍️',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3,
                      children: List.generate(
                        10,
                            (i) =>
                            TextField(
                              controller: controllers[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Word',
                                hintStyle: TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: Colors.deepPurple.withOpacity(0.8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: _btnStyle(),
                      onPressed: () {
                        final userInputs = controllers.map((e) =>
                            e.text.toLowerCase()).toList();
                        int score = userInputs
                            .where((element) => correctWords.contains(element))
                            .length;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ResultScreen(score: score)));
                      },
                      child: Text('Check Score',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({super.key, required this.score});

  String getMessage() {
    if (score == 10) return '🔥 Incredible Memory! You nailed it!';
    if (score >= 7) return '💪 Great Job! Keep it up!';
    if (score >= 4) return '👍 Nice! You can improve!';
    if (score >= 1) return '🤔 You remembered some. Try again!';
    return '😅 Better luck next time!';
  }

  Color getColor() {
    if (score == 10) return Colors.amber;
    if (score >= 7) return Colors.greenAccent;
    if (score >= 4) return Colors.lightBlueAccent;
    if (score >= 1) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _bgGradient(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration, size: 100, color: getColor()),
              SizedBox(height: 20),
              Text(
                'Your Score: $score / 10',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: getColor()),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  getMessage(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 40),

              // Play Again Button
              ElevatedButton(
                style: _btnStyle(),
                child: Text('Play Again'),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),

              SizedBox(height: 10), // Spacing between buttons

              // Go to Home Button
              ElevatedButton(
                style: _btnStyle(),
                child: Text('Go to Home'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


BoxDecoration _bgGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFFFF9C4), Color(0xFFE1BEE7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

ButtonStyle _btnStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFCE93D8),
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    shadowColor: Color(0xFFB39DDB),
    elevation: 10,
  );
}
