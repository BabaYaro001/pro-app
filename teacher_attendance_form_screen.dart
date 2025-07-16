import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../db/database_helper.dart';
import '../models/teacher_attendance.dart';

class TeacherAttendanceFormScreen extends StatefulWidget {
  final String teacherName;
  final String teacherId;
  const TeacherAttendanceFormScreen({
    super.key,
    required this.teacherName,
    required this.teacherId,
  });

  @override
  State<TeacherAttendanceFormScreen> createState() => _TeacherAttendanceFormScreenState();
}

class _TeacherAttendanceFormScreenState extends State<TeacherAttendanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _status = "Present";
  String? _locationStr;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() => _loading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location service disabled");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => _locationStr = "${pos.latitude},${pos.longitude}");
    } catch (e) {
      setState(() => _locationStr = "Unavailable");
    }
    setState(() => _loading = false);
  }

  void _save() async {
    if (_locationStr == null || _locationStr == "Unavailable") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location required!'))
      );
      return;
    }
    final now = DateTime.now();
    final att = TeacherAttendance(
      teacherName: widget.teacherName,
      teacherId: widget.teacherId,
      date: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      time: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
      status: _status,
      location: _locationStr!,
    );
    await DatabaseHelper.instance.insertTeacherAttendance(att);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance marked')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text("Mark Your Attendance")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text("Teacher: ${widget.teacherName} (${widget.teacherId})"),
                    const SizedBox(height: 8),
                    Text("Date: ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"),
                    Text("Time: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Status: "),
                        DropdownButton<String>(
                          value: _status,
                          items: const [
                            DropdownMenuItem(value: "Present", child: Text("Present")),
                            DropdownMenuItem(value: "Absent", child: Text("Absent")),
                            DropdownMenuItem(value: "Late", child: Text("Late")),
                            DropdownMenuItem(value: "Excused", child: Text("Excused")),
                          ],
                          onChanged: (val) => setState(() => _status = val!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Location: ${_locationStr ?? 'Getting...'}"),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _save,
                      child: const Text("Mark Attendance"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}