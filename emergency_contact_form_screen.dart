import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/emergency_contact.dart';

class EmergencyContactFormScreen extends StatefulWidget {
  final EmergencyContact? contact;
  const EmergencyContactFormScreen({super.key, this.contact});

  @override
  State<EmergencyContactFormScreen> createState() => _EmergencyContactFormScreenState();
}

class _EmergencyContactFormScreenState extends State<EmergencyContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _roleController.text = widget.contact!.role;
      _phoneController.text = widget.contact!.phone;
      _emailController.text = widget.contact!.email;
      _descriptionController.text = widget.contact!.description;
    }
  }

  void _saveContact() async {
    if (_formKey.currentState?.validate() ?? false) {
      final contact = EmergencyContact(
        id: widget.contact?.id,
        name: _nameController.text,
        role: _roleController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        description: _descriptionController.text,
      );

      if (widget.contact == null) {
        await DatabaseHelper.instance.insertEmergencyContact(contact);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Emergency contact added')));
      } else {
        await DatabaseHelper.instance.updateEmergencyContact(contact);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Emergency contact updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? "Add Emergency Contact" : "Edit Emergency Contact"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: "Role/Position"),
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
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description (Department, shift, etc.)"),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveContact,
                child: Text(widget.contact == null ? "Add Contact" : "Update Contact"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}