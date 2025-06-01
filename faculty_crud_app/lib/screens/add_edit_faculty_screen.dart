import 'package:flutter/material.dart';
import '../models/faculty.dart';
import '../services/api_service.dart';

class AddFacultyScreen extends StatefulWidget {
  const AddFacultyScreen({super.key});

  @override
  State<AddFacultyScreen> createState() => _AddFacultyScreenState();
}

class _AddFacultyScreenState extends State<AddFacultyScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final faculty = Faculty(
        id: int.tryParse(idController.text),
        name: nameController.text,
        email: emailController.text,
        dateOfBirth: dobController.text,
        contact: contactController.text,
        department: deptController.text,
        designation: designationController.text,
        address: addressController.text,
      );

      try {
        await ApiService.addFaculty(faculty);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faculty added successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add faculty: $e')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    contactController.dispose();
    deptController.dispose();
    designationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Add Faculty'),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Faculty Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: idController,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration('ID', Icons.numbers),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter ID';
                      if (int.tryParse(value) == null) return 'ID must be a number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: nameController,
                    decoration: _buildInputDecoration('Name', Icons.person),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter name' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: emailController,
                    decoration: _buildInputDecoration('Email', Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter email';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: dobController,
                    readOnly: true,
                    decoration: _buildInputDecoration('Date of Birth', Icons.calendar_today)
                        .copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select date of birth' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: contactController,
                    decoration: _buildInputDecoration('Contact', Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter contact' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: deptController,
                    decoration: _buildInputDecoration('Department', Icons.account_tree),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter department' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: designationController,
                    decoration: _buildInputDecoration('Designation', Icons.badge),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter designation' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: addressController,
                    decoration: _buildInputDecoration('Address', Icons.home),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter address' : null,
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save),
                      label: const Text('Add Faculty'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
