import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/announcement.dart';
import 'announcement_form_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  late Future<List<Announcement>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _refreshAnnouncements();
  }

  void _refreshAnnouncements() {
    setState(() {
      _announcementsFuture = DatabaseHelper.instance.getAllAnnouncements();
    });
  }

  void _addAnnouncement() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AnnouncementFormScreen()),
    );
    if (result == true) _refreshAnnouncements();
  }

  void _editAnnouncement(Announcement announcement) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AnnouncementFormScreen(announcement: announcement)),
    );
    if (result == true) _refreshAnnouncements();
  }

  void _deleteAnnouncement(int id) async {
    await DatabaseHelper.instance.deleteAnnouncement(id);
    _refreshAnnouncements();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAnnouncement,
            tooltip: "Add Announcement",
          )
        ],
      ),
      body: FutureBuilder<List<Announcement>>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No announcements found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final announcement = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.announcement)),
                title: Text(announcement.title),
                subtitle: Text(
                  '${announcement.content}\nBy: ${announcement.author} | Date: ${announcement.date}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editAnnouncement(announcement),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAnnouncement(announcement.id!),
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