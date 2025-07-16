import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/cafeteria_item.dart';

class CafeteriaFormScreen extends StatefulWidget {
  final CafeteriaItem? item;
  const CafeteriaFormScreen({super.key, this.item});

  @override
  State<CafeteriaFormScreen> createState() => _CafeteriaFormScreenState();
}

class _CafeteriaFormScreenState extends State<CafeteriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = "Meal";
  String _available = "Yes";

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description;
      _priceController.text = widget.item!.price.toString();
      _category = widget.item!.category;
      _available = widget.item!.available;
    }
  }

  void _saveItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      final item = CafeteriaItem(
        id: widget.item?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        category: _category,
        available: _available,
      );

      if (widget.item == null) {
        await DatabaseHelper.instance.insertCafeteriaItem(item);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cafeteria item added')));
      } else {
        await DatabaseHelper.instance.updateCafeteriaItem(item);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cafeteria item updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? "Add Cafeteria Item" : "Edit Cafeteria Item"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.isEmpty || double.tryParse(v) == null)
                        ? "Enter valid price"
                        : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Category: "),
                  DropdownButton<String>(
                    value: _category,
                    items: const [
                      DropdownMenuItem(value: "Meal", child: Text("Meal")),
                      DropdownMenuItem(value: "Snack", child: Text("Snack")),
                      DropdownMenuItem(value: "Drink", child: Text("Drink")),
                    ],
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Available: "),
                  DropdownButton<String>(
                    value: _available,
                    items: const [
                      DropdownMenuItem(value: "Yes", child: Text("Yes")),
                      DropdownMenuItem(value: "No", child: Text("No")),
                    ],
                    onChanged: (val) => setState(() => _available = val!),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(widget.item == null ? "Add Item" : "Update Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}