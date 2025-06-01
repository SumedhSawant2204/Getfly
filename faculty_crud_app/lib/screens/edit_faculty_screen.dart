import 'package:flutter/material.dart';
import '../models/faculty.dart';
import '../services/api_service.dart';

class EditFacultyScreen extends StatefulWidget {
  final Faculty faculty;

  const EditFacultyScreen({super.key, required this.faculty});

  @override
  State<EditFacultyScreen> createState() => _EditFacultyScreenState();
}

class _EditFacultyScreenState extends State<EditFacultyScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController contactController;
  late TextEditingController deptController;
  late TextEditingController designationController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.faculty.id?.toString() ?? '');
    nameController = TextEditingController(text: widget.faculty.name);
    emailController = TextEditingController(text: widget.faculty.email);
    dobController = TextEditingController(text: widget.faculty.dateOfBirth);
    contactController = TextEditingController(text: widget.faculty.contact);
    deptController = TextEditingController(text: widget.faculty.department);
    designationController = TextEditingController(text: widget.faculty.designation);
    addressController = TextEditingController(text: widget.faculty.address);
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate = DateTime.parse(dobController.text);
    } catch (_) {
      initialDate = DateTime(1990);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
        await ApiService.updateFaculty(faculty);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faculty updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update faculty: $e')),
        );
      }
    }
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
        title: const Text('Edit Faculty'),
        backgroundColor: Colors.blue.shade600,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update Faculty Information',
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
                    readOnly: true,
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
                      label: const Text('Update Faculty'),
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
