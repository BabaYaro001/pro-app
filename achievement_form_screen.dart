import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/achievement.dart';

class AchievementFormScreen extends StatefulWidget {
  final Achievement? achievement;
  const AchievementFormScreen({super.key, this.achievement});

  @override
  State<AchievementFormScreen> createState() => _AchievementFormScreenState();
}

class _AchievementFormScreenState extends State<AchievementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _studentNameController = TextEditingController();
  DateTime _date = DateTime.now();
  String _type = "Academic";

  @override
  void initState() {
    super.initState();
    if (widget.achievement != null) {
      _titleController.text = widget.achievement!.title;
      _descriptionController.text = widget.achievement!.description;
      _studentNameController.text = widget.achievement!.studentName;
      _date = DateTime.tryParse(widget.achievement!.date) ?? DateTime.now();
      _type = widget.achievement!.type;
    }
  }

  void _saveAchievement() async {
    if (_formKey.currentState?.validate() ?? false) {
      final achievement = Achievement(
        id: widget.achievement?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        studentName: _studentNameController.text,
        date:
            "${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}",
        type: _type,
      );

      if (widget.achievement == null) {
        await DatabaseHelper.instance.insertAchievement(achievement);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Achievement added')));
      } else {
        await DatabaseHelper.instance.updateAchievement(achievement);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Achievement updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.achievement == null ? "Add Achievement" : "Edit Achievement"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
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
                controller: _studentNameController,
                decoration: const InputDecoration(labelText: "Student Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Date: "),
                  Text(
                      "${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}"),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Type: "),
                  DropdownButton<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: "Academic", child: Text("Academic")),
                      DropdownMenuItem(value: "Sports", child: Text("Sports")),
                      DropdownMenuItem(value: "Arts", child: Text("Arts")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (val) => setState(() => _type = val!),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveAchievement,
                child: Text(widget.achievement == null ? "Add Achievement" : "Update Achievement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}