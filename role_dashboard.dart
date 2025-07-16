import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'teacher_dashboard.dart';
import 'student_dashboard.dart';
import 'parent_dashboard.dart';

enum UserRole { admin, teacher, student, parent }

class RoleDashboard extends StatelessWidget {
  final UserRole role;
  final String name; // Add user name for greeting

  const RoleDashboard({super.key, required this.role, this.name = "User"});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.admin:
        return AdminDashboard(adminName: name);
      case UserRole.teacher:
        return TeacherDashboard(teacherName: name);
      case UserRole.student:
        return StudentDashboard(studentName: name);
      case UserRole.parent:
        return ParentDashboard(parentName: name);
    }
  }
}