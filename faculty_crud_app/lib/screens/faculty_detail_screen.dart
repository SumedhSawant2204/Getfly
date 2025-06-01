import 'package:flutter/material.dart';
import '../models/faculty.dart';

class FacultyDetailScreen extends StatelessWidget {
  final Faculty faculty;

  const FacultyDetailScreen({super.key, required this.faculty});

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(faculty.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow('ID', faculty.id?.toString() ?? ''),
            buildRow('Name', faculty.name),
            buildRow('Email', faculty.email),
            buildRow('Date of Birth', faculty.dateOfBirth),
            buildRow('Contact', faculty.contact),
            buildRow('Department', faculty.department),
            buildRow('Designation', faculty.designation),
            buildRow('Address', faculty.address),
          ],
        ),
      ),
    );
  }
}
