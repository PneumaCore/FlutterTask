import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;

  Widget _buildDeadlinePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _selectedDeadline == null
                ? 'No deadline selected.'
                : 'Deadline: ${DateFormat('d MMMM, yyyy', 'en_US').format(_selectedDeadline!)}',
          ),
        ),
        TextButton(
          child: const Text('Select deadline'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _selectedDeadline = picked;
              });
            }
          },
        ),
        if (_selectedDeadline != null)
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Remove deadline',
          onPressed: () {
            setState(() {
              _selectedDeadline = null;
            });
          },
        ),
      ],
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        deadline: _selectedDeadline,
      );

      Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Add a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Add a description' : null,
              ),
              _buildDeadlinePicker(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
