import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/resource.dart';

class ResourceFormScreen extends StatefulWidget {
  final Resource? resource;
  const ResourceFormScreen({super.key, this.resource});

  @override
  State<ResourceFormScreen> createState() => _ResourceFormScreenState();
}

class _ResourceFormScreenState extends State<ResourceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _uploadedByController = TextEditingController();
  DateTime _uploadDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.resource != null) {
      _titleController.text = widget.resource!.title;
      _descriptionController.text = widget.resource!.description;
      _urlController.text = widget.resource!.url;
      _uploadedByController.text = widget.resource!.uploadedBy;
      _uploadDate = DateTime.tryParse(widget.resource!.uploadDate) ?? DateTime.now();
    }
  }

  void _saveResource() async {
    if (_formKey.currentState?.validate() ?? false) {
      final resource = Resource(
        id: widget.resource?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        url: _urlController.text,
        uploadedBy: _uploadedByController.text,
        uploadDate: "${_uploadDate.year}-${_uploadDate.month.toString().padLeft(2, '0')}-${_uploadDate.day.toString().padLeft(2, '0')}",
      );

      if (widget.resource == null) {
        await DatabaseHelper.instance.insertResource(resource);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resource added')));
      } else {
        await DatabaseHelper.instance.updateResource(resource);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resource updated')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resource == null ? "Add Resource" : "Edit Resource"),
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
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: "URL"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _uploadedByController,
                decoration: const InputDecoration(labelText: "Uploaded By"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Upload Date: "),
                  Text("${_uploadDate.year}-${_uploadDate.month.toString().padLeft(2, '0')}-${_uploadDate.day.toString().padLeft(2, '0')}"),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _uploadDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _uploadDate = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saveResource,
                child: Text(widget.resource == null ? "Add Resource" : "Update Resource"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}