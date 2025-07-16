import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshStudents();
  }

  void _refreshStudents() {
    setState(() {
      _studentsFuture = DatabaseHelper.instance.getAllStudents();
    });
  }

  void _addStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormScreen()),
    );
    if (result == true) _refreshStudents();
  }

  void _editStudent(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(student: student)),
    );
    if (result == true) _refreshStudents();
  }

  void _deleteStudent(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    _refreshStudents();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addStudent,
            tooltip: "Add Student",
          )
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No students found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return ListTile(
                leading: student.photoPath.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: AssetImage(student.photoPath),
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(student.name),
                subtitle: Text('${student.section} - ${student.className}\n${student.email}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editStudent(student),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteStudent(student.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}