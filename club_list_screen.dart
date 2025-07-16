import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/club.dart';
import 'club_form_screen.dart';

class ClubListScreen extends StatefulWidget {
  const ClubListScreen({super.key});

  @override
  State<ClubListScreen> createState() => _ClubListScreenState();
}

class _ClubListScreenState extends State<ClubListScreen> {
  late Future<List<Club>> _clubsFuture;

  @override
  void initState() {
    super.initState();
    _refreshClubs();
  }

  void _refreshClubs() {
    setState(() {
      _clubsFuture = DatabaseHelper.instance.getAllClubs();
    });
  }

  void _addClub() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClubFormScreen()),
    );
    if (result == true) _refreshClubs();
  }

  void _editClub(Club club) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ClubFormScreen(club: club)),
    );
    if (result == true) _refreshClubs();
  }

  void _deleteClub(int id) async {
    await DatabaseHelper.instance.deleteClub(id);
    _refreshClubs();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Club deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clubs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addClub,
            tooltip: "Add Club",
          )
        ],
      ),
      body: FutureBuilder<List<Club>>(
        future: _clubsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No clubs found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final club = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.groups)),
                title: Text(club.name),
                subtitle: Text(
                  '${club.description}\nAdvisor: ${club.facultyAdvisor}\nMeet: ${club.meetingTime}\nCategory: ${club.category}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editClub(club),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteClub(club.id!),
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