import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/event.dart';
import 'event_form_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = DatabaseHelper.instance.getAllEvents();
    });
  }

  void _addEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EventFormScreen()),
    );
    if (result == true) _refreshEvents();
  }

  void _editEvent(Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => EventFormScreen(event: event)),
    );
    if (result == true) _refreshEvents();
  }

  void _deleteEvent(int id) async {
    await DatabaseHelper.instance.deleteEvent(id);
    _refreshEvents();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEvent,
            tooltip: "Add Event",
          )
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final event = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.event)),
                title: Text(event.title),
                subtitle: Text(
                  '${event.description}\nLocation: ${event.location}\nBy: ${event.organizer} | Date: ${event.date}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editEvent(event),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteEvent(event.id!),
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