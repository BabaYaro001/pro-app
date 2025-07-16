import 'package:flutter/material.dart';
import 'drawer_menu.dart';

class ParentDashboard extends StatelessWidget {
  final String parentName;
  const ParentDashboard({super.key, required this.parentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Dashboard")),
      drawer: DrawerMenu(
        userName: parentName,
        onLogout: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          Text("Welcome, $parentName!",
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
                  icon: Icons.child_care,
                  label: "Child's Attendance",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.grade,
                  label: "Child's Grades",
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
              _DashboardTile(
                  icon: Icons.money,
                  label: "Fees",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.directions_bus,
                  label: "Transport",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.restaurant_menu,
                  label: "Cafeteria",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.groups,
                  label: "Clubs",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.emoji_events,
                  label: "Achievements",
                  onTap: () {}),
              _DashboardTile(
                  icon: Icons.warning,
                  label: "Emergency Info",
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