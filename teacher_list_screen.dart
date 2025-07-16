import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/teacher.dart';
import 'teacher_form_screen.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _refreshTeachers();
  }

  void _refreshTeachers() {
    setState(() {
      _teachersFuture = DatabaseHelper.instance.getAllTeachers();
    });
  }

  void _addTeacher() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TeacherFormScreen()),
    );
    if (result == true) _refreshTeachers();
  }

  void _editTeacher(Teacher teacher) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeacherFormScreen(teacher: teacher)),
    );
    if (result == true) _refreshTeachers();
  }

  void _deleteTeacher(int id) async {
    await DatabaseHelper.instance.deleteTeacher(id);
    _refreshTeachers();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teachers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTeacher,
            tooltip: "Add Teacher",
          )
        ],
      ),
      body: FutureBuilder<List<Teacher>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No teachers found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final teacher = snapshot.data![index];
              return ListTile(
                leading: teacher.photoPath.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: AssetImage(teacher.photoPath),
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(teacher.name),
                subtitle: Text('${teacher.section} - ${teacher.className}\n${teacher.email}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editTeacher(teacher),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTeacher(teacher.id!),
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