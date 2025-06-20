import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homepage/screens/home_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // now storing sender info

  // IMPORTANT: Add /chat to the end of your ngrok URL
  final String backendUrl = 'https://cf13-2409-4080-ee85-f7d-577e-1874-137c-3910.ngrok-free.app/chat'; // Fixed: added /chat

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _controller.clear();
    });

    try {
      print('Sending request to: $backendUrl'); // Debug print
      print('Message: $text'); // Debug print
      
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true', // Skip ngrok browser warning
        },
        body: jsonEncode({'message': text}),
      );

      print('Response status code: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = data['response'] ?? 'No response from bot';

        setState(() {
          _messages.add({'sender': 'bot', 'text': botReply});
        });
      } else {
        print('Server error: ${response.statusCode}'); // Debug print
        setState(() {
          _messages.add({
            'sender': 'bot', 
            'text': 'Server error (${response.statusCode}): ${response.body}'
          });
        });
      }
    } catch (e) {
      print('Connection error: $e'); // Debug print
      setState(() {
        _messages.add({
          'sender': 'bot', 
          'text': 'Connection failed: $e'
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Color(0xFF90CAF9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        title: Text(
          'Luna',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Connection status indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.green.shade100,
            child: Text(
              'Connected to: ${backendUrl.replaceAll('https://', '').split('/')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.green.shade800),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.white : Color(0xFFBBDEFB),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: SelectableText(
                      message['text'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF90CAF9),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}