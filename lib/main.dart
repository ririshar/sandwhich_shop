import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App', // Updated title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PlainWhiteScreen(), // Updated to a plain white screen
    );
  }
}

class PlainWhiteScreen extends StatelessWidget {
  const PlainWhiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Shop'), // Label for the screen
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          'Sandwich Shop',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white, // Plain white background
    );
  }
}
