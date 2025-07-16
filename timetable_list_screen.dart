import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/timetable.dart';
import 'timetable_form_screen.dart';

class TimetableListScreen extends StatefulWidget {
  const TimetableListScreen({super.key});

  @override
  State<TimetableListScreen> createState() => _TimetableListScreenState();
}

class _TimetableListScreenState extends State<TimetableListScreen> {
  late Future<List<TimetableEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _refreshTimetable();
  }

  void _refreshTimetable() {
    setState(() {
      _entriesFuture = DatabaseHelper.instance.getAllTimetableEntries();
    });
  }

  void _addEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TimetableFormScreen()),
    );
    if (result == true) _refreshTimetable();
  }

  void _editEntry(TimetableEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TimetableFormScreen(entry: entry)),
    );
    if (result == true) _refreshTimetable();
  }

  void _deleteEntry(int id) async {
    await DatabaseHelper.instance.deleteTimetableEntry(id);
    _refreshTimetable();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timetable entry deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timetable"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEntry,
            tooltip: "Add Entry",
          )
        ],
      ),
      body: FutureBuilder<List<TimetableEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No timetable entries found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final entry = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.schedule)),
                title: Text('${entry.className} - ${entry.section}'),
                subtitle: Text(
                  'Day: ${entry.day}\nPeriod: ${entry.period}\nSubject: ${entry.subject}\nTeacher: ${entry.teacher}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editEntry(entry),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteEntry(entry.id!),
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