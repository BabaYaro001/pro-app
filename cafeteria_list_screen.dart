import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/cafeteria_item.dart';
import 'cafeteria_form_screen.dart';

class CafeteriaListScreen extends StatefulWidget {
  const CafeteriaListScreen({super.key});

  @override
  State<CafeteriaListScreen> createState() => _CafeteriaListScreenState();
}

class _CafeteriaListScreenState extends State<CafeteriaListScreen> {
  late Future<List<CafeteriaItem>> _cafeteriaFuture;

  @override
  void initState() {
    super.initState();
    _refreshCafeteria();
  }

  void _refreshCafeteria() {
    setState(() {
      _cafeteriaFuture = DatabaseHelper.instance.getAllCafeteriaItems();
    });
  }

  void _addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CafeteriaFormScreen()),
    );
    if (result == true) _refreshCafeteria();
  }

  void _editItem(CafeteriaItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CafeteriaFormScreen(item: item)),
    );
    if (result == true) _refreshCafeteria();
  }

  void _deleteItem(int id) async {
    await DatabaseHelper.instance.deleteCafeteriaItem(id);
    _refreshCafeteria();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cafeteria item deleted successfully')));
  }

  Color _availabilityColor(String available) {
    switch (available) {
      case "Yes":
        return Colors.green;
      case "No":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cafeteria"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
            tooltip: "Add Item",
          )
        ],
      ),
      body: FutureBuilder<List<CafeteriaItem>>(
        future: _cafeteriaFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No cafeteria items found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _availabilityColor(item.available),
                  child: const Icon(Icons.restaurant_menu, color: Colors.white),
                ),
                title: Text(item.name),
                subtitle: Text(
                  '${item.description}\nCategory: ${item.category} | Price: \$${item.price.toStringAsFixed(2)}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.available,
                        style: TextStyle(color: _availabilityColor(item.available))),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editItem(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(item.id!),
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