import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/timetable.dart';

class TimetableFormScreen extends StatefulWidget {
  final TimetableEntry? entry;
  const TimetableFormScreen({super.key, this.entry});

  @override
  State<TimetableFormScreen> createState() => _TimetableFormScreenState();
}

class _TimetableFormScreenState extends State<TimetableFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _dayController = TextEditingController();
  final _periodController = TextEditingController();
  final _subjectController = TextEditingController();
  final _teacherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _classNameController.text = widget.entry!.className;
      _sectionController.text = widget.entry!.section;
      _dayController.text = widget.entry!.day;
      _periodController.text = widget.entry!.period;
      _subjectController.text = widget.entry!.subject;
      _teacherController.text = widget.entry!.teacher;
    }
  }

  void _saveEntry() async {
    if (_formKey.currentState?.validate() ?? false) {
      final entry = TimetableEntry(
        id: widget.entry?.id,
        className: _classNameController.text,
        section: _sectionController.text,
        day: _dayController.text,
        period: _periodController.text,
        subject: _subjectController.text,
        teacher: _teacherController.text,
      );

      if (widget.entry == null) {
        await DatabaseHelper.instance.insertTimetableEntry(entry);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Timetable entry added')));
      } else {
        await DatabaseHelper.instance.updateTimetableEntry(entry);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Timetable entry updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? "Add Timetable Entry" : "Edit Timetable Entry"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(labelText: "Class"),
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
                controller: _dayController,
                decoration: const InputDecoration(labelText: "Day"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _periodController,
                decoration: const InputDecoration(labelText: "Period"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: "Subject"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(labelText: "Teacher"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveEntry,
                child: Text(widget.entry == null ? "Add Entry" : "Update Entry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}