import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You can connect this to your notifications provider or database
    final notifications = [
      "Welcome to the School Management App!",
      "Your account has been successfully created.",
      "Remember to check your assignments regularly.",
      // Add more sample or fetched notifications
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.notifications_active, color: Colors.blue),
          title: Text(notifications[index]),
        ),
      ),
    );
  }
}