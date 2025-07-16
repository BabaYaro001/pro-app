import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/fee.dart';

class FeeFormScreen extends StatefulWidget {
  final Fee? fee;
  const FeeFormScreen({super.key, this.fee});

  @override
  State<FeeFormScreen> createState() => _FeeFormScreenState();
}

class _FeeFormScreenState extends State<FeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();
  final _classNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _typeController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _status = "Pending";

  @override
  void initState() {
    super.initState();
    if (widget.fee != null) {
      _studentNameController.text = widget.fee!.studentName;
      _classNameController.text = widget.fee!.className;
      _sectionController.text = widget.fee!.section;
      _typeController.text = widget.fee!.type;
      _amountController.text = widget.fee!.amount.toString();
      _dueDate = DateTime.tryParse(widget.fee!.dueDate) ?? DateTime.now();
      _status = widget.fee!.status;
    }
  }

  void _saveFee() async {
    if (_formKey.currentState?.validate() ?? false) {
      final fee = Fee(
        id: widget.fee?.id,
        studentName: _studentNameController.text,
        className: _classNameController.text,
        section: _sectionController.text,
        type: _typeController.text,
        amount: double.tryParse(_amountController.text) ?? 0,
        dueDate: "${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}",
        status: _status,
      );

      if (widget.fee == null) {
        await DatabaseHelper.instance.insertFee(fee);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fee record added')));
      } else {
        await DatabaseHelper.instance.updateFee(fee);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fee record updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fee == null ? "Add Fee" : "Edit Fee"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _studentNameController,
                decoration: const InputDecoration(labelText: "Student Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(labelText: "Class"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(labelText: "Section"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Fee Type (e.g., Tuition, Transport)"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.isEmpty || double.tryParse(v) == null)
                        ? "Enter valid amount"
                        : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Due Date: "),
                  Text("${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}"),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Status: "),
                  DropdownButton<String>(
                    value: _status,
                    items: const [
                      DropdownMenuItem(value: "Paid", child: Text("Paid")),
                      DropdownMenuItem(value: "Pending", child: Text("Pending")),
                      DropdownMenuItem(value: "Overdue", child: Text("Overdue")),
                    ],
                    onChanged: (val) => setState(() => _status = val!),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveFee,
                child: Text(widget.fee == null ? "Add Fee" : "Update Fee"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}