import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'home_screen.dart';

void main() {
  runApp(MentalHealthMusicApp());
}

class MentalHealthMusicApp extends StatelessWidget {
  const MentalHealthMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Music Player',
      debugShowCheckedModeBanner: false,
      home: MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  int _currentIndex = 1; // Default index for Home

  final List<String> sections = ['Calming Music', 'Breathing Techniques', 'Guided Meditation'];

  final Map<String, List<Map<String, String>>> playlistData = {
    'Calming Music': [
      {'title': 'Calm Mind', 'url': 'assets/calm1.mp3'},
      {'title': 'Evening Peace', 'url': 'assets/calm2.mp3'},
      {'title': 'Night Serenity', 'url': 'assets/calm3.mp3'},
    ],
    'Breathing Techniques': [
      {'title': '4-7-8 Breath', 'url': 'assets/breath1.mp3'},
      {'title': 'Box Breathing', 'url': 'assets/breath2.mp3'},
    ],
    'Guided Meditation': [
      {'title': 'Morning Boost', 'url': 'assets/guided1.mp3'},
      {'title': 'Relax Sleep', 'url': 'assets/guided2.mp3'},
    ],
  };

  void _onSectionTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle navigation when tab is clicked
    if (index == 1) {
      // Home tab is clicked, stay on the current screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (index == 0) {
      // Chatbot clicked but no screen exists, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chatbot feature coming soon!")),
      );
    } else if (index == 2) {
      // Dashboard clicked but no screen exists, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dashboard feature coming soon!")),
      );
    }
  }

  Widget _buildTopTabs() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Row(
        children: List.generate(sections.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Container(height: 30, width: 1, color: Colors.grey.shade300, margin: EdgeInsets.symmetric(horizontal: 8));
          }
          int index = i ~/ 2;
          bool isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onSectionTap(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    sections[index],
                    style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlaylist(String section) {
    final items = playlistData[section] ?? [];
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.only(bottom: 16),
          color: Colors.white.withOpacity(0.9),
          child: ListTile(
            leading: Image.asset("assets/meditation.jpg", width: 40, height: 40, fit: BoxFit.cover),
            title: Text(item['title']!, style: TextStyle(fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.play_arrow),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MusicPlayerScreen(
                    title: item['title']!,
                    url: item['url']!,
                    section: section,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9EDF6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Mindful Music",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTopTabs(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: sections.length,
              onPageChanged: (index) => setState(() => _selectedIndex = index),
              itemBuilder: (_, index) => _buildPlaylist(sections[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF89B4E6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
      ),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String url;
  final String section;

  const MusicPlayerScreen({super.key, required this.title, required this.url, required this.section});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setAsset(widget.url);
      await _player.play();

      _player.durationStream.listen((d) {
        if (d != null) setState(() => _duration = d);
      });

      _player.positionStream.listen((p) {
        setState(() => _position = p);
      });

      _player.playerStateStream.listen((state) {
        setState(() => isPlaying = state.playing);
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _skipForward() {
    final newPosition = _position + Duration(seconds: 10);
    if (newPosition < _duration) {
      _player.seek(newPosition);
    }
  }

  void _skipBackward() {
    final newPosition = _position - Duration(seconds: 10);
    _player.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (widget.section) {
      case 'Guided Meditation':
        bgColor = Color(0xFFD9EDF6);
        break;
      case 'Breathing Techniques':
        bgColor = Color(0xFFD9EDF6);
        break;
      case 'Calming Music':
      default:
        bgColor = Color(0xFFD9EDF6);
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.title, style: TextStyle(color: Colors.black87)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset("assets/meditation.jpg", width: 300, height: 300, fit: BoxFit.cover),
                SizedBox(height: 20),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Slider(
                      min: 0,
                      max: _duration.inMilliseconds.toDouble(),
                      value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.teal,
                      inactiveColor: Colors.teal.shade100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position), style: TextStyle(color: Colors.black87)),
                        Text(_formatDuration(_duration), style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.replay_10), iconSize: 40, onPressed: _skipBackward),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                      iconSize: 60,
                      color: Colors.teal,
                      onPressed: _togglePlay,
                    ),
                    IconButton(icon: Icon(Icons.forward_10), iconSize: 40, onPressed: _skipForward),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}