import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

void main() => runApp(ThreeSensesGame());

class ThreeSensesGame extends StatelessWidget {
  const ThreeSensesGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3 Senses Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: ThreeHome(),
    );
  }
}

class ThreeHome extends StatelessWidget {
  const ThreeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _bgGradient(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 40.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.self_improvement, size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Three Senses Game',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Feel the moment, focus your senses 🧘‍♀️',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 300,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                        'How to Play:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildBulletPoint('You will have to sit in a relaxed position.'),
                      _buildBulletPoint('You have to close your eyes for 1 minute.'),
                      _buildBulletPoint('After 1 minute, write down what you feel, hear, and see.'),
                      _buildBulletPoint("It's easy! You can do this!")    ,
                    
                      ],
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: _btnStyle(),
                      child: Text('Start Game',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TimerScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // 🔘 Custom method to build bullet points
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(color: Colors.white, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }



class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => InputScreen()));
      } else {
        setState(() => _seconds--);
      }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer, size: 90, color: Colors.white),
              SizedBox(height: 30),
              Text('Focus on your surroundings...',
                  style: TextStyle(fontSize: 22, color: Colors.white)),
              SizedBox(height: 30),
              Text(
                '$_seconds',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputScreen extends StatelessWidget {
  final _hearCtrl = TextEditingController();
  final _feelCtrl = TextEditingController();
  final _seeCtrl = TextEditingController();

  InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _bgGradient(),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Reflect & Write ✍️",
                    style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),

                _buildInputBox(
                  controller: _hearCtrl,
                  label: 'What did you HEAR? 🎧',
                  icon: Icons.hearing,
                ),
                SizedBox(height: 20),
                _buildInputBox(
                  controller: _feelCtrl,
                  label: 'What did you FEEL? 🤲',
                  icon: Icons.self_improvement,
                ),
                SizedBox(height: 20),
                _buildInputBox(
                  controller: _seeCtrl,
                  label: 'What did you SEE? 🌈',
                  icon: Icons.visibility,
                ),

                SizedBox(height: 40),

                // Submit Button (No dialog box now)
                ElevatedButton(
                  style: _btnStyle(),
                  onPressed: () {
                    // Perform any action (if needed)
                  },
                  child: Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),

                SizedBox(height: 20),

                // Play Again Button (Navigates to ThreeHome)
                ElevatedButton(
                  style: _btnStyle(),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ThreeHome()),
                    );
                  },
                  child: Text('Play Again', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),

                SizedBox(height: 10),

                // Go Home Button (Navigates to HomeScreen)
                ElevatedButton(
                  style: _btnStyle(),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text('Go Home', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.purple.shade100, blurRadius: 8, offset: Offset(2, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 2,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


BoxDecoration _bgGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFB2EBF2), Color(0xFFD1C4E9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

ButtonStyle _btnStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    shadowColor: Colors.purpleAccent,
    elevation: 10,
  );
}
