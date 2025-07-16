import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/parent.dart';
import 'parent_form_screen.dart';

class ParentListScreen extends StatefulWidget {
  const ParentListScreen({super.key});

  @override
  State<ParentListScreen> createState() => _ParentListScreenState();
}

class _ParentListScreenState extends State<ParentListScreen> {
  late Future<List<Parent>> _parentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshParents();
  }

  void _refreshParents() {
    setState(() {
      _parentsFuture = DatabaseHelper.instance.getAllParents();
    });
  }

  void _addParent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ParentFormScreen()),
    );
    if (result == true) _refreshParents();
  }

  void _editParent(Parent parent) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ParentFormScreen(parent: parent)),
    );
    if (result == true) _refreshParents();
  }

  void _deleteParent(int id) async {
    await DatabaseHelper.instance.deleteParent(id);
    _refreshParents();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parent deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parents"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addParent,
            tooltip: "Add Parent",
          )
        ],
      ),
      body: FutureBuilder<List<Parent>>(
        future: _parentsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No parents found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final parent = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.people)),
                title: Text(parent.name),
                subtitle: Text('Child: ${parent.studentName} (${parent.studentClass}, ${parent.studentSection})\n${parent.email}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editParent(parent),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteParent(parent.id!),
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