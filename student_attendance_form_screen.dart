import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student_attendance.dart';

class StudentAttendanceFormScreen extends StatefulWidget {
  final String className;
  final String section;
  final String teacherName;
  final List<Map<String, String>> students; // [{'name':..., 'id':...}, ...]

  const StudentAttendanceFormScreen({
    super.key,
    required this.className,
    required this.section,
    required this.teacherName,
    required this.students,
  });

  @override
  State<StudentAttendanceFormScreen> createState() => _StudentAttendanceFormScreenState();
}

class _StudentAttendanceFormScreenState extends State<StudentAttendanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _attendanceStatus = {};

  @override
  void initState() {
    super.initState();
    for (var student in widget.students) {
      _attendanceStatus[student['id']!] = 'Present';
    }
  }

  void _save() async {
    final now = DateTime.now();
    for (var student in widget.students) {
      final att = StudentAttendance(
        studentName: student['name']!,
        studentId: student['id']!,
        className: widget.className,
        section: widget.section,
        date: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        status: _attendanceStatus[student['id']!]!,
        takenBy: widget.teacherName,
      );
      await DatabaseHelper.instance.insertStudentAttendance(att);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance recorded')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Take Attendance ${widget.className}-${widget.section}")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.students.length,
                itemBuilder: (ctx, i) {
                  final student = widget.students[i];
                  return ListTile(
                    title: Text("${student['name']} (${student['id']})"),
                    trailing: DropdownButton<String>(
                      value: _attendanceStatus[student['id']!],
                      items: const [
                        DropdownMenuItem(value: "Present", child: Text("Present")),
                        DropdownMenuItem(value: "Absent", child: Text("Absent")),
                        DropdownMenuItem(value: "Late", child: Text("Late")),
                        DropdownMenuItem(value: "Excused", child: Text("Excused")),
                      ],
                      onChanged: (val) => setState(() => _attendanceStatus[student['id']!] = val!),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: _save, child: const Text("Submit")),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}