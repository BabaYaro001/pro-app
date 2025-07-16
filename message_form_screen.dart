import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/message.dart';

class MessageFormScreen extends StatefulWidget {
  final Message? message;
  const MessageFormScreen({super.key, this.message});

  @override
  State<MessageFormScreen> createState() => _MessageFormScreenState();
}

class _MessageFormScreenState extends State<MessageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senderController = TextEditingController();
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime _timestamp = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.message != null) {
      _senderController.text = widget.message!.sender;
      _recipientController.text = widget.message!.recipient;
      _subjectController.text = widget.message!.subject;
      _contentController.text = widget.message!.content;
      _timestamp = DateTime.tryParse(widget.message!.timestamp) ?? DateTime.now();
    }
  }

  void _saveMessage() async {
    if (_formKey.currentState?.validate() ?? false) {
      final message = Message(
        id: widget.message?.id,
        sender: _senderController.text,
        recipient: _recipientController.text,
        subject: _subjectController.text,
        content: _contentController.text,
        timestamp:
            "${_timestamp.year}-${_timestamp.month.toString().padLeft(2, '0')}-${_timestamp.day.toString().padLeft(2, '0')} ${_timestamp.hour.toString().padLeft(2, '0')}:${_timestamp.minute.toString().padLeft(2, '0')}",
      );

      if (widget.message == null) {
        await DatabaseHelper.instance.insertMessage(message);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message sent')));
      } else {
        await DatabaseHelper.instance.updateMessage(message);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.message == null ? "Send Message" : "Edit Message"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _senderController,
                decoration: const InputDecoration(labelText: "Sender"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(labelText: "Recipient (All/Role/Username)"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: "Subject"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: "Content"),
                maxLines: 5,
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
                onPressed: _saveMessage,
                child: Text(widget.message == null ? "Send Message" : "Update Message"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}