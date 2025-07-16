import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _gender = "Male";
  final _dobController = TextEditingController();
  final _admissionDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _sectionController = TextEditingController();
  final _classNameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  String _photoPath = "";

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _gender = widget.student!.gender;
      _dobController.text = widget.student!.dob;
      _admissionDateController.text = widget.student!.admissionDate;
      _addressController.text = widget.student!.address;
      _emailController.text = widget.student!.email;
      _sectionController.text = widget.student!.section;
      _classNameController.text = widget.student!.className;
      _parentNameController.text = widget.student!.parentName;
      _parentPhoneController.text = widget.student!.parentPhone;
      _photoPath = widget.student!.photoPath;
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

  void _saveStudent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final student = Student(
        id: widget.student?.id,
        name: _nameController.text,
        gender: _gender,
        dob: _dobController.text,
        admissionDate: _admissionDateController.text,
        address: _addressController.text,
        email: _emailController.text,
        section: _sectionController.text,
        className: _classNameController.text,
        parentName: _parentNameController.text,
        parentPhone: _parentPhoneController.text,
        photoPath: _photoPath,
      );

      if (widget.student == null) {
        await DatabaseHelper.instance.insertStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student added successfully')));
      } else {
        await DatabaseHelper.instance.updateStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student updated successfully')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? "Add Student" : "Edit Student"),
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Gender: "),
                  Radio<String>(
                    value: "Male",
                    groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                  const Text("Male"),
                  Radio<String>(
                    value: "Female",
                    groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                  const Text("Female"),
                ],
              ),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.tryParse(_dobController.text) ??
                        DateTime(2010, 1, 1),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dobController.text =
                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _admissionDateController,
                decoration: const InputDecoration(labelText: "Admission Date"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.tryParse(_admissionDateController.text) ??
                        DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _admissionDateController.text =
                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
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
                controller: _parentNameController,
                decoration: const InputDecoration(labelText: "Parent Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _parentPhoneController,
                decoration: const InputDecoration(labelText: "Parent Phone"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveStudent,
                child: Text(widget.student == null ? "Add Student" : "Update Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}