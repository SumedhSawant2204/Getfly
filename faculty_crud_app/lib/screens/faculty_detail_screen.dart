import 'package:flutter/material.dart';
import '../models/faculty.dart';

class FacultyDetailScreen extends StatelessWidget {
  final Faculty faculty;

  const FacultyDetailScreen({super.key, required this.faculty});

  Widget buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(faculty.name),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/default_avatar.png'), // replace with network or asset if available
                  ),
                  const SizedBox(height: 16),
                  Text(
                    faculty.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildRow(Icons.badge, 'ID', faculty.id?.toString() ?? ''),
                  buildRow(Icons.email, 'Email', faculty.email),
                  buildRow(Icons.cake, 'Date of Birth', faculty.dateOfBirth),
                  buildRow(Icons.phone, 'Contact', faculty.contact),
                  buildRow(Icons.school, 'Department', faculty.department),
                  buildRow(Icons.work, 'Designation', faculty.designation),
                  buildRow(Icons.home, 'Address', faculty.address),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
