import 'package:flutter/material.dart';
import 'package:xo_Game/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
         primarySwatch: Colors.blue,
         primaryColor: const Color(0xFF00061a),
         shadowColor: const Color(0xFF001456),
         splashColor: const Color(0xFF4169e8),
         ),
      debugShowCheckedModeBanner: false,
      title: 'XO game',
      home: const HomePage(),
    );
  }
}
