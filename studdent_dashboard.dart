import 'package:flutter/material.dart';
import 'drawer_menu.dart';

class StudentDashboard extends StatelessWidget {
  final String studentName;
  const StudentDashboard({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      drawer: DrawerMenu(
        userName: studentName,
        onLogout: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          Text("Welcome, $studentName!",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _DashboardTile(
                  icon: Icons.account_circle,
                  label: "My Profile",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.how_to_reg,
                  label: "Attendance",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.grade,
                  label: "Gradebook",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.class_,
                  label: "Timetable",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.assignment,
                  label: "Assignments",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.announcement,
                  label: "Announcements",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.event,
                  label: "Events",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.book,
                  label: "Resources",
                  onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DashboardTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blue),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}