import 'package:flutter/material.dart';
import '../models/faculty.dart';
import '../services/api_service.dart';
import 'faculty_detail_screen.dart';
import 'edit_faculty_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Faculty> faculties = [];

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    final data = await ApiService.fetchFaculties();
    setState(() {
      faculties = data;
    });
  }

  Future<void> _deleteFaculty(int id, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this faculty?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteFaculty(id);
        setState(() {
          faculties.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faculty deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete faculty: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faculty List')),
      body: faculties.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: faculties.length,
              itemBuilder: (context, index) {
                final faculty = faculties[index];
                return ListTile(
                  title: Text(faculty.name),
                  subtitle: Text(faculty.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FacultyDetailScreen(faculty: faculty),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditFacultyScreen(faculty: faculty),
                            ),
                          );
                          if (result == true) {
                            _loadFaculties(); // Refresh after edit
                          }
                        },
                      ),

                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (faculty.id != null) {
                            _deleteFaculty(faculty.id!, index);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.pushNamed(context, '/add');
          if (added == true) {
            _loadFaculties(); // Refresh after adding
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
