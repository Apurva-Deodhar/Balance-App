import 'package:flutter/material.dart';
import 'dart:async';
import 'firstpage.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import '/firebase_options.dart'; // This file is generated after you configure Firebase

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase options for your platform
  );
  runApp(const BalanceApp());
}

class BalanceApp extends StatelessWidget {
  const BalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balance',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;
  late AnimationController _waveController;
  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo pop animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoScaleAnimation = CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack);
    _logoController.forward();

    // Wave animation
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Tagline text fade-in
    _textFadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_textFadeController);

    // Delay tagline text a bit
    Future.delayed(const Duration(milliseconds: 1000), () {
      _textFadeController.forward();
    });

    // Firebase check
    _checkFirebaseConnection();

    // Navigate to home after splash
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => FirstPage()),
      );
    });
  }

  // Firebase connection check function
  void _checkFirebaseConnection() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase is connected successfully!');
    } catch (e) {
      print('❌ Firebase connection failed: $e');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _waveController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            painter: FilledWavePainter(_waveController.value),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with scale animation
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Image.asset(
                      'assets/Logo1.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tagline with fade animation
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      "Welcome to Balance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FilledWavePainter extends CustomPainter {
  final double progress;
  FilledWavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 1; i <= 3; i++) {
      final double radius = (progress * 300) + (i * 40);
      final Paint paint = Paint()
        ..color = Colors.lightBlueAccent.withOpacity((1 - progress) * (0.25 / i))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FilledWavePainter oldDelegate) => true;
}
