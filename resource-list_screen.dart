import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/resource.dart';
import 'resource_form_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceListScreen extends StatefulWidget {
  const ResourceListScreen({super.key});

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  late Future<List<Resource>> _resourcesFuture;

  @override
  void initState() {
    super.initState();
    _refreshResources();
  }

  void _refreshResources() {
    setState(() {
      _resourcesFuture = DatabaseHelper.instance.getAllResources();
    });
  }

  void _addResource() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResourceFormScreen()),
    );
    if (result == true) _refreshResources();
  }

  void _editResource(Resource resource) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ResourceFormScreen(resource: resource)),
    );
    if (result == true) _refreshResources();
  }

  void _deleteResource(int id) async {
    await DatabaseHelper.instance.deleteResource(id);
    _refreshResources();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resource deleted successfully')));
  }

  void _openResourceUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resources"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addResource,
            tooltip: "Add Resource",
          )
        ],
      ),
      body: FutureBuilder<List<Resource>>(
        future: _resourcesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No resources found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final resource = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.link)),
                title: Text(resource.title),
                subtitle: Text(
                  '${resource.description}\nBy: ${resource.uploadedBy} | Date: ${resource.uploadDate}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new, color: Colors.green),
                      onPressed: () => _openResourceUrl(resource.url),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editResource(resource),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteResource(resource.id!),
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