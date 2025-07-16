import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/notification.dart';
import 'notification_form_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotifications();
  }

  void _refreshNotifications() {
    setState(() {
      _notificationsFuture = DatabaseHelper.instance.getAllNotifications();
    });
  }

  void _addNotification() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationFormScreen()),
    );
    if (result == true) _refreshNotifications();
  }

  void _editNotification(NotificationModel notification) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => NotificationFormScreen(notification: notification)),
    );
    if (result == true) _refreshNotifications();
  }

  void _deleteNotification(int id) async {
    await DatabaseHelper.instance.deleteNotification(id);
    _refreshNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: _addNotification,
            tooltip: "Send Notification",
          )
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final notif = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.notifications)),
                title: Text(notif.title),
                subtitle: Text(
                  '${notif.body}\nTo: ${notif.recipient} | ${notif.timestamp}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editNotification(notif),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNotification(notif.id!),
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