import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/teacher.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TeacherFormScreen extends StatefulWidget {
  final Teacher? teacher;
  const TeacherFormScreen({super.key, this.teacher});

  @override
  State<TeacherFormScreen> createState() => _TeacherFormScreenState();
}

class _TeacherFormScreenState extends State<TeacherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _sectionController = TextEditingController();
  final _classNameController = TextEditingController();
  final _educationController = TextEditingController();
  String _photoPath = "";

  @override
  void initState() {
    super.initState();
    if (widget.teacher != null) {
      _usernameController.text = widget.teacher!.username;
      _passwordController.text = widget.teacher!.password;
      _nameController.text = widget.teacher!.name;
      _addressController.text = widget.teacher!.address;
      _phoneController.text = widget.teacher!.phone;
      _emailController.text = widget.teacher!.email;
      _sectionController.text = widget.teacher!.section;
      _classNameController.text = widget.teacher!.className;
      _educationController.text = widget.teacher!.education;
      _photoPath = widget.teacher!.photoPath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _photoPath = picked.path;
      });
    }
  }

  void _saveTeacher() async {
    if (_formKey.currentState?.validate() ?? false) {
      final teacher = Teacher(
        id: widget.teacher?.id,
        username: _usernameController.text,
        password: _passwordController.text,
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        section: _sectionController.text,
        className: _classNameController.text,
        education: _educationController.text,
        photoPath: _photoPath,
      );

      if (widget.teacher == null) {
        await DatabaseHelper.instance.insertTeacher(teacher);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Teacher added successfully')));
      } else {
        await DatabaseHelper.instance.updateTeacher(teacher);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Teacher updated successfully')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher == null ? "Add Teacher" : "Edit Teacher"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      _photoPath.isNotEmpty ? FileImage(File(_photoPath)) : null,
                  child: _photoPath.isEmpty
                      ? const Icon(Icons.person, size: 48)
                      : null,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(labelText: "Section"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(labelText: "Class"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(labelText: "Education"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveTeacher,
                child: Text(widget.teacher == null ? "Add Teacher" : "Update Teacher"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}