import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/emergency_contact.dart';
import 'emergency_contact_form_screen.dart';

class EmergencyContactListScreen extends StatefulWidget {
  const EmergencyContactListScreen({super.key});

  @override
  State<EmergencyContactListScreen> createState() => _EmergencyContactListScreenState();
}

class _EmergencyContactListScreenState extends State<EmergencyContactListScreen> {
  late Future<List<EmergencyContact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _refreshContacts();
  }

  void _refreshContacts() {
    setState(() {
      _contactsFuture = DatabaseHelper.instance.getAllEmergencyContacts();
    });
  }

  void _addContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmergencyContactFormScreen()),
    );
    if (result == true) _refreshContacts();
  }

  void _editContact(EmergencyContact contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmergencyContactFormScreen(contact: contact)),
    );
    if (result == true) _refreshContacts();
  }

  void _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteEmergencyContact(id);
    _refreshContacts();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency contact deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addContact,
            tooltip: "Add Emergency Contact",
          )
        ],
      ),
      body: FutureBuilder<List<EmergencyContact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No emergency contacts found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final contact = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.warning, color: Colors.red)),
                title: Text(contact.name),
                subtitle: Text(
                  '${contact.role}\nPhone: ${contact.phone}\nEmail: ${contact.email}\n${contact.description}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editContact(contact),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteContact(contact.id!),
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