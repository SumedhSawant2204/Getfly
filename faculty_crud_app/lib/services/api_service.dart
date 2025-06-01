import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/faculty.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/faculties';

  // ✅ Fetch all faculty
  static Future<List<Faculty>> fetchFaculties() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Faculty.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load faculties');
    }
  }

  // ✅ Add faculty
  static Future<void> addFaculty(Faculty faculty) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(faculty.toJson()),
    );
  }

  // ✅ Delete faculty
  static Future<void> deleteFaculty(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception('Failed to delete faculty');
  }
}

  // Optional: Update faculty (if needed)
  static Future<void> updateFaculty(Faculty faculty) async {
    if (faculty.id == null) throw Exception("Faculty ID is required for update");
    await http.put(
      Uri.parse('$baseUrl/${faculty.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(faculty.toJson()),
    );
  }
}
