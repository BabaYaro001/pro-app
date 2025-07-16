import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/teacher_attendance.dart';

class TeacherAttendanceListScreen extends StatefulWidget {
  final String userRole; // 'admin' or 'teacher'
  final String userId;   // teacher's id if role = teacher

  const TeacherAttendanceListScreen({
    super.key,
    required this.userRole,
    required this.userId,
  });

  @override
  State<TeacherAttendanceListScreen> createState() => _TeacherAttendanceListScreenState();
}

class _TeacherAttendanceListScreenState extends State<TeacherAttendanceListScreen> {
  late Future<List<TeacherAttendance>> _attFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      if (widget.userRole == 'admin') {
        _attFuture = DatabaseHelper.instance.getAllTeacherAttendance();
      } else {
        _attFuture = DatabaseHelper.instance.getTeacherAttendanceByTeacherId(widget.userId);
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
      appBar: AppBar(title: const Text("Teacher Attendance")),
      body: FutureBuilder<List<TeacherAttendance>>(
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
                title: Text("${att.teacherName} (${att.teacherId})"),
                subtitle: Text("Date: ${att.date}  Time: ${att.time}\nStatus: ${att.status}\nLocation: ${att.location}"),
                isThreeLine: true,
              );
            });
        },
      ),
    );
  }
}