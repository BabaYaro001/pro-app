import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transport.dart';

class TransportFormScreen extends StatefulWidget {
  final Transport? transport;
  const TransportFormScreen({super.key, this.transport});

  @override
  State<TransportFormScreen> createState() => _TransportFormScreenState();
}

class _TransportFormScreenState extends State<TransportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _driverPhoneController = TextEditingController();
  final _routeController = TextEditingController();
  String _type = "Bus";
  String _status = "Active";

  @override
  void initState() {
    super.initState();
    if (widget.transport != null) {
      _vehicleNumberController.text = widget.transport!.vehicleNumber;
      _driverNameController.text = widget.transport!.driverName;
      _driverPhoneController.text = widget.transport!.driverPhone;
      _routeController.text = widget.transport!.route;
      _type = widget.transport!.type;
      _status = widget.transport!.status;
    }
  }

  void _saveTransport() async {
    if (_formKey.currentState?.validate() ?? false) {
      final transport = Transport(
        id: widget.transport?.id,
        vehicleNumber: _vehicleNumberController.text,
        driverName: _driverNameController.text,
        driverPhone: _driverPhoneController.text,
        route: _routeController.text,
        type: _type,
        status: _status,
      );

      if (widget.transport == null) {
        await DatabaseHelper.instance.insertTransport(transport);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transport record added')));
      } else {
        await DatabaseHelper.instance.updateTransport(transport);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transport record updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transport == null ? "Add Transport" : "Edit Transport"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(labelText: "Vehicle Number"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _driverNameController,
                decoration: const InputDecoration(labelText: "Driver Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _driverPhoneController,
                decoration: const InputDecoration(labelText: "Driver Phone"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _routeController,
                decoration: const InputDecoration(labelText: "Route"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Type: "),
                  DropdownButton<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: "Bus", child: Text("Bus")),
                      DropdownMenuItem(value: "Van", child: Text("Van")),
                      DropdownMenuItem(value: "Car", child: Text("Car")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (val) => setState(() => _type = val!),
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
                      DropdownMenuItem(value: "Active", child: Text("Active")),
                      DropdownMenuItem(value: "Maintenance", child: Text("Maintenance")),
                      DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
                    ],
                    onChanged: (val) => setState(() => _status = val!),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveTransport,
                child: Text(widget.transport == null ? "Add Transport" : "Update Transport"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}