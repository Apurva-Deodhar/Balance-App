import 'dart:convert';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breathing Techniques',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lightBlue ),
      home: BreathingTechniquesPage(),
    );
  }
}

class BreathingTechniquesPage extends StatelessWidget {
  const BreathingTechniquesPage({super.key});

  Future<List<Widget>> createList(BuildContext context) async {
    List<Widget> items = [];
    String dataString = await DefaultAssetBundle.of(context).loadString("assets/data.json");
    List<dynamic> dataJSON = jsonDecode(dataString);

    for (var object in dataJSON) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Square Image (Left side)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      object["techniqueImage"],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.0),

                  // Text Column (Right side)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Technique Name (Bold)
                        Text(
                          object["techniqueName"],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),

                        // Steps (each step in a new line)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (object["howTo"] as List<dynamic>)
                              .map<Widget>((step) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              "• $step",
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Breathing Techniques"),
        backgroundColor: Color(0xFFD9EDF6), // This removes the pink color
        elevation: 0, // Optional: removes the shadow
      ),
      backgroundColor: Color(0xFFD9EDF6), // This ensures the full page is white
      body: FutureBuilder<List<Widget>>(
        future: createList(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No techniques available"));
          } else {
            return ListView(children: snapshot.data!);
          }
        },
      ),
    );
  }
}
