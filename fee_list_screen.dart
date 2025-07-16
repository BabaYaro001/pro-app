import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/fee.dart';
import 'fee_form_screen.dart';

class FeeListScreen extends StatefulWidget {
  const FeeListScreen({super.key});

  @override
  State<FeeListScreen> createState() => _FeeListScreenState();
}

class _FeeListScreenState extends State<FeeListScreen> {
  late Future<List<Fee>> _feesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFees();
  }

  void _refreshFees() {
    setState(() {
      _feesFuture = DatabaseHelper.instance.getAllFees();
    });
  }

  void _addFee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FeeFormScreen()),
    );
    if (result == true) _refreshFees();
  }

  void _editFee(Fee fee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FeeFormScreen(fee: fee)),
    );
    if (result == true) _refreshFees();
  }

  void _deleteFee(int id) async {
    await DatabaseHelper.instance.deleteFee(id);
    _refreshFees();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fee entry deleted successfully')));
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Overdue":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fees"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFee,
            tooltip: "Add Fee",
          )
        ],
      ),
      body: FutureBuilder<List<Fee>>(
        future: _feesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No fee records found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final fee = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _statusColor(fee.status),
                  child: const Icon(Icons.attach_money, color: Colors.white),
                ),
                title: Text("${fee.studentName} (${fee.className}-${fee.section})"),
                subtitle: Text(
                  'Type: ${fee.type}\nAmount: \$${fee.amount.toStringAsFixed(2)}\nDue: ${fee.dueDate}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(fee.status, style: TextStyle(color: _statusColor(fee.status))),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editFee(fee),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFee(fee.id!),
                    ),
                  ],
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}