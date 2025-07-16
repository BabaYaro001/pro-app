import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student_attendance.dart';

class StudentAttendanceListScreen extends StatefulWidget {
  final String userRole; // 'admin', 'teacher', 'parent'
  final String? userId; // teacherId or parentId (for filtering)
  final String? className;
  final String? section;
  final String? studentId; // for parent

  const StudentAttendanceListScreen({
    super.key,
    required this.userRole,
    this.userId,
    this.className,
    this.section,
    this.studentId,
  });

  @override
  State<StudentAttendanceListScreen> createState() => _StudentAttendanceListScreenState();
}

class _StudentAttendanceListScreenState extends State<StudentAttendanceListScreen> {
  late Future<List<StudentAttendance>> _attFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      if (widget.userRole == 'admin') {
        _attFuture = DatabaseHelper.instance.getAllStudentAttendance();
      } else if (widget.userRole == 'teacher' && widget.className != null && widget.section != null) {
        _attFuture = DatabaseHelper.instance.getStudentAttendanceForClassDate(
          widget.className!, widget.section!, DateTime.now().toIso8601String().substring(0, 10));
      } else if (widget.userRole == 'parent' && widget.studentId != null) {
        _attFuture = DatabaseHelper.instance.getStudentAttendanceByStudentId(widget.studentId!);
      } else {
        _attFuture = Future.value([]);
      }
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Present": return Colors.green;
      case "Absent": return Colors.red;
      case "Late": return Colors.orange;
      case "Excused": return Colors.blue;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Attendance")),
      body: FutureBuilder<List<StudentAttendance>>(
        future: _attFuture,
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          if (snap.data!.isEmpty) return const Center(child: Text("No records found."));
          return ListView.separated(
            itemCount: snap.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (ctx, i) {
              final att = snap.data![i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _statusColor(att.status),
                  child: const Icon(Icons.person),
                ),
                title: Text("${att.studentName} (${att.studentId})"),
                subtitle: Text("Class: ${att.className}-${att.section}\nDate: ${att.date}\nStatus: ${att.status}\nTaken by: ${att.takenBy}"),
                isThreeLine: true,
              );
            });
        },
      ),
    );
  }
}