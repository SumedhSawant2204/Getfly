import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_faculty_screen.dart';

void main() {
  runApp(const FacultyApp());
}

class FacultyApp extends StatelessWidget {
  const FacultyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faculty CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/add': (context) => const AddFacultyScreen(),
      },
    );
  }
}
