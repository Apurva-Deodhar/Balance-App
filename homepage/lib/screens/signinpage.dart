import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    // Try silent sign-in on initialization
    _trySilentSignIn();
  }

  Future<void> _trySilentSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      if (account != null) {
        await _handleGoogleSignIn(account);
      }
    } catch (e) {
      // Silent sign-in failed, user needs to explicitly sign in
      print('Silent sign-in failed: $e');
    }
  }

  Future<void> _handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // For web, use the newer approach
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          await _handleGoogleSignIn(googleUser);
        }
      } else {
        // For mobile platforms, the original approach still works
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          await _handleGoogleSignIn(googleUser);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDEFFA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopCurvedSection(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildTitle(),
                            const SizedBox(height: 20),
                            _buildTextField(nameController, "Name", validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            }),
                            const SizedBox(height: 10),
                            _buildTextField(emailController, "Email", validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            }),
                            const SizedBox(height: 10),
                            _buildTextField(
                              passwordController,
                              "Password",
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildSignInButton(context),
                            const SizedBox(height: 20),
                            _buildOrSignInWithText(),
                            const SizedBox(height: 10),
                            _buildGoogleSignInButton(context),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCurvedSection() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/profile_icon.png"),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                "Welcome to Balance",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Sign In",
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            await _auth.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF939697),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            "Sign In",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrSignInWithText() {
    return Text(
      "Or Sign in with",
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: _signInWithGoogle,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Image.asset(
          "assets/google_icon.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}