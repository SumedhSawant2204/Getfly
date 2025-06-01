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
        dobController.text = picked.toIso8601String().split('T')[0]; // yyyy-mm-dd
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
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add faculty: $e')),
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
      appBar: AppBar(title: const Text('Add Faculty')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ID Field (int)
              TextFormField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter ID';
                  if (int.tryParse(value) == null) return 'ID must be a number';
                  return null;
                },
              ),

              // Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter name' : null,
              ),

              // Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter email';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              // Date of Birth with DatePicker
              TextFormField(
                controller: dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please select date of birth' : null,
              ),

              // Contact
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter contact' : null,
              ),

              // Department
              TextFormField(
                controller: deptController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter department' : null,
              ),

              // Designation
              TextFormField(
                controller: designationController,
                decoration: const InputDecoration(labelText: 'Designation'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter designation' : null,
              ),

              // Address
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter address' : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Faculty'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
