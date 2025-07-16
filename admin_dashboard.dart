import 'package:flutter/material.dart';
import 'drawer_menu.dart';

class AdminDashboard extends StatelessWidget {
  final String adminName;
  const AdminDashboard({super.key, required this.adminName});

  void _showWelcomeMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome, new user has been added!')));
    // You can also trigger a notification or dialog here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      drawer: DrawerMenu(
        userName: adminName,
        onLogout: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text("Welcome, $adminName!",
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
                  icon: Icons.person,
                  label: "Teachers",
                  onTap: () {
                    // Navigate to teacher management
                  }),
              _DashboardTile(
                  icon: Icons.school,
                  label: "Students",
                  onTap: () {
                    // Navigate to student management
                  }),
              _DashboardTile(
                  icon: Icons.people_alt,
                  label: "Parents",
                  onTap: () {
                    // Navigate to parent management
                  }),
              _DashboardTile(
                  icon: Icons.calendar_month,
                  label: "Timetable",
                  onTap: () {
                    // Navigate to timetable management
                  }),
              _DashboardTile(
                  icon: Icons.announcement,
                  label: "Announcements",
                  onTap: () {
                    // Navigate to announcement management
                  }),
              _DashboardTile(
                  icon: Icons.event,
                  label: "Events",
                  onTap: () {
                    // Navigate to events screen
                  }),
              _DashboardTile(
                  icon: Icons.book,
                  label: "Resources",
                  onTap: () {
                    // Navigate to resources screen
                  }),
              _DashboardTile(
                  icon: Icons.money,
                  label: "Fees",
                  onTap: () {
                    // Navigate to fees management
                  }),
              _DashboardTile(
                  icon: Icons.directions_bus,
                  label: "Transport",
                  onTap: () {
                    // Navigate to transport management
                  }),
              _DashboardTile(
                  icon: Icons.restaurant_menu,
                  label: "Cafeteria",
                  onTap: () {
                    // Navigate to cafeteria management
                  }),
              _DashboardTile(
                  icon: Icons.groups,
                  label: "Clubs",
                  onTap: () {
                    // Navigate to clubs management
                  }),
              _DashboardTile(
                  icon: Icons.emoji_events,
                  label: "Achievements",
                  onTap: () {
                    // Navigate to achievements
                  }),
              _DashboardTile(
                  icon: Icons.warning,
                  label: "Emergency Contacts",
                  onTap: () {
                    // Navigate to emergency contacts
                  }),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text("Add New User"),
            onPressed: () {
              // After successful add, show welcome notification
              _showWelcomeMessage(context);
            },
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