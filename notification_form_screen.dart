import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/notification.dart';

class NotificationFormScreen extends StatefulWidget {
  final NotificationModel? notification;
  const NotificationFormScreen({super.key, this.notification});

  @override
  State<NotificationFormScreen> createState() => _NotificationFormScreenState();
}

class _NotificationFormScreenState extends State<NotificationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _recipientController = TextEditingController();
  DateTime _timestamp = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.notification != null) {
      _titleController.text = widget.notification!.title;
      _bodyController.text = widget.notification!.body;
      _recipientController.text = widget.notification!.recipient;
      _timestamp = DateTime.tryParse(widget.notification!.timestamp) ?? DateTime.now();
    }
  }

  void _saveNotification() async {
    if (_formKey.currentState?.validate() ?? false) {
      final notification = NotificationModel(
        id: widget.notification?.id,
        title: _titleController.text,
        body: _bodyController.text,
        recipient: _recipientController.text,
        timestamp:
            "${_timestamp.year}-${_timestamp.month.toString().padLeft(2, '0')}-${_timestamp.day.toString().padLeft(2, '0')} ${_timestamp.hour.toString().padLeft(2, '0')}:${_timestamp.minute.toString().padLeft(2, '0')}",
      );

      if (widget.notification == null) {
        await DatabaseHelper.instance.insertNotification(notification);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification sent')));
      } else {
        await DatabaseHelper.instance.updateNotification(notification);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notification == null ? "Send Notification" : "Edit Notification"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: "Body"),
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(labelText: "Recipient (All/Role/Username)"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Timestamp: "),
                  Text(
                      "${_timestamp.year}-${_timestamp.month.toString().padLeft(2, '0')}-${_timestamp.day.toString().padLeft(2, '0')} ${_timestamp.hour.toString().padLeft(2, '0')}:${_timestamp.minute.toString().padLeft(2, '0')}"),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _timestamp,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_timestamp),
                        );
                        setState(() {
                          _timestamp = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime?.hour ?? _timestamp.hour,
                            pickedTime?.minute ?? _timestamp.minute,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveNotification,
                child: Text(widget.notification == null ? "Send Notification" : "Update Notification"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}