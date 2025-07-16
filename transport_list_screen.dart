import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transport.dart';
import 'transport_form_screen.dart';

class TransportListScreen extends StatefulWidget {
  const TransportListScreen({super.key});

  @override
  State<TransportListScreen> createState() => _TransportListScreenState();
}

class _TransportListScreenState extends State<TransportListScreen> {
  late Future<List<Transport>> _transportsFuture;

  @override
  void initState() {
    super.initState();
    _refreshTransports();
  }

  void _refreshTransports() {
    setState(() {
      _transportsFuture = DatabaseHelper.instance.getAllTransports();
    });
  }

  void _addTransport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransportFormScreen()),
    );
    if (result == true) _refreshTransports();
  }

  void _editTransport(Transport transport) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => TransportFormScreen(transport: transport)),
    );
    if (result == true) _refreshTransports();
  }

  void _deleteTransport(int id) async {
    await DatabaseHelper.instance.deleteTransport(id);
    _refreshTransports();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transport record deleted successfully')));
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Maintenance":
        return Colors.orange;
      case "Inactive":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transport"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTransport,
            tooltip: "Add Transport",
          )
        ],
      ),
      body: FutureBuilder<List<Transport>>(
        future: _transportsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No transport records found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final transport = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _statusColor(transport.status),
                  child: const Icon(Icons.directions_bus, color: Colors.white),
                ),
                title: Text("${transport.vehicleNumber} (${transport.type})"),
                subtitle: Text(
                  'Driver: ${transport.driverName} (${transport.driverPhone})\nRoute: ${transport.route}\nStatus: ${transport.status}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editTransport(transport),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTransport(transport.id!),
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