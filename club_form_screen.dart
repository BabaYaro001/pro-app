import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/club.dart';

class ClubFormScreen extends StatefulWidget {
  final Club? club;
  const ClubFormScreen({super.key, this.club});

  @override
  State<ClubFormScreen> createState() => _ClubFormScreenState();
}

class _ClubFormScreenState extends State<ClubFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _facultyAdvisorController = TextEditingController();
  final _meetingTimeController = TextEditingController();
  String _category = "Sports";

  @override
  void initState() {
    super.initState();
    if (widget.club != null) {
      _nameController.text = widget.club!.name;
      _descriptionController.text = widget.club!.description;
      _facultyAdvisorController.text = widget.club!.facultyAdvisor;
      _meetingTimeController.text = widget.club!.meetingTime;
      _category = widget.club!.category;
    }
  }

  void _saveClub() async {
    if (_formKey.currentState?.validate() ?? false) {
      final club = Club(
        id: widget.club?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        facultyAdvisor: _facultyAdvisorController.text,
        meetingTime: _meetingTimeController.text,
        category: _category,
      );

      if (widget.club == null) {
        await DatabaseHelper.instance.insertClub(club);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Club added')));
      } else {
        await DatabaseHelper.instance.updateClub(club);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Club updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.club == null ? "Add Club" : "Edit Club"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Club Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _facultyAdvisorController,
                decoration: const InputDecoration(labelText: "Faculty Advisor"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _meetingTimeController,
                decoration: const InputDecoration(labelText: "Meeting Time"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Category: "),
                  DropdownButton<String>(
                    value: _category,
                    items: const [
                      DropdownMenuItem(value: "Sports", child: Text("Sports")),
                      DropdownMenuItem(value: "Science", child: Text("Science")),
                      DropdownMenuItem(value: "Arts", child: Text("Arts")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveClub,
                child: Text(widget.club == null ? "Add Club" : "Update Club"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}