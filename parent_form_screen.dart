import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/parent.dart';

class ParentFormScreen extends StatefulWidget {
  final Parent? parent;
  const ParentFormScreen({super.key, this.parent});

  @override
  State<ParentFormScreen> createState() => _ParentFormScreenState();
}

class _ParentFormScreenState extends State<ParentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _studentClassController = TextEditingController();
  final _studentSectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.parent != null) {
      _nameController.text = widget.parent!.name;
      _phoneController.text = widget.parent!.phone;
      _emailController.text = widget.parent!.email;
      _addressController.text = widget.parent!.address;
      _studentNameController.text = widget.parent!.studentName;
      _studentClassController.text = widget.parent!.studentClass;
      _studentSectionController.text = widget.parent!.studentSection;
    }
  }

  void _saveParent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final parent = Parent(
        id: widget.parent?.id,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        studentName: _studentNameController.text,
        studentClass: _studentClassController.text,
        studentSection: _studentSectionController.text,
      );

      if (widget.parent == null) {
        await DatabaseHelper.instance.insertParent(parent);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Parent added successfully')));
      } else {
        await DatabaseHelper.instance.updateParent(parent);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Parent updated successfully')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parent == null ? "Add Parent" : "Edit Parent"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Parent Name"),
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
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              const Divider(),
              TextFormField(
                controller: _studentNameController,
                decoration: const InputDecoration(labelText: "Child Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _studentClassController,
                decoration: const InputDecoration(labelText: "Child Class"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _studentSectionController,
                decoration: const InputDecoration(labelText: "Child Section"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveParent,
                child: Text(widget.parent == null ? "Add Parent" : "Update Parent"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}