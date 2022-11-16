import 'package:exercises_assistant_app/controllers/globals.dart';
import 'package:exercises_assistant_app/views/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  Globals.init();
  runApp(const ExercisesApp());
}

class ExercisesApp extends StatelessWidget {
  const ExercisesApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise Finder',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}
