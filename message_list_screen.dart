import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/message.dart';
import 'message_form_screen.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  late Future<List<Message>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _refreshMessages();
  }

  void _refreshMessages() {
    setState(() {
      _messagesFuture = DatabaseHelper.instance.getAllMessages();
    });
  }

  void _addMessage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MessageFormScreen()),
    );
    if (result == true) _refreshMessages();
  }

  void _editMessage(Message message) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MessageFormScreen(message: message)),
    );
    if (result == true) _refreshMessages();
  }

  void _deleteMessage(int id) async {
    await DatabaseHelper.instance.deleteMessage(id);
    _refreshMessages();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMessage,
            tooltip: "Send Message",
          )
        ],
      ),
      body: FutureBuilder<List<Message>>(
        future: _messagesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No messages found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final msg = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.mail)),
                title: Text(msg.subject),
                subtitle: Text(
                  '${msg.content}\nFrom: ${msg.sender} | To: ${msg.recipient} | ${msg.timestamp}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editMessage(msg),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMessage(msg.id!),
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