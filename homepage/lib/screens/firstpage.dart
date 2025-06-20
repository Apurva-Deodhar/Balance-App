import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'signinpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_icon.png'), // Add image
            backgroundColor: Colors.transparent,
          ),
          SizedBox(height: 40),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFCDEFFA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  _buildButton(context, "Create Account"),
                  SizedBox(height: 20),
                  _buildButton(context, "Log In"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          if (text == "Log In") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else if (text == "Create Account") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}