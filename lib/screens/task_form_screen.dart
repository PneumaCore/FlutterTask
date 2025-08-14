import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? existingTask;

  const TaskFormScreen({super.key, this.existingTask});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final bool _isEdit;
  DateTime? _selectedDeadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Task' : 'New Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: _isEdit ? 'Save' : 'Create',
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

  @override
  void initState() {
    super.initState();
    _isEdit = widget.existingTask != null;

    _titleController = TextEditingController(
      text: _isEdit ? widget.existingTask!.title : '',
    );

    _descriptionController = TextEditingController(
      text: _isEdit ? widget.existingTask!.description : '',
    );

    _selectedDeadline = _isEdit ? widget.existingTask!.deadline : null;
  }

  // Widget to build the deadline picker.
  Widget _buildDeadlinePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _selectedDeadline == null
                ? 'No deadline selected.'
                : 'Deadline: ${DateFormat('d MMMM, yyyy', 'en_US').format(_selectedDeadline!)}.',
          ),
        ),
        TextButton(
          child: const Text('Select deadline'),
          onPressed: () async {
            final today = DateTime.now();
            final initialDate =
                _selectedDeadline != null && _selectedDeadline!.isAfter(today)
                ? _selectedDeadline!
                : today;
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: today,
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

  // Method to save the new or edited task.
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (_isEdit) {
        final updatedTask = Task(
          id: widget.existingTask!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          isDone: widget.existingTask!.isDone,
          createdAt: widget.existingTask!.createdAt,
          deadline: _selectedDeadline,
        );
        taskProvider.updateTask(widget.existingTask!.id, updatedTask);
      } else {
        final newTask = Task(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          createdAt: DateTime.now(),
          deadline: _selectedDeadline,
        );
        taskProvider.addTask(newTask);
      }

      Navigator.pop(context);
    }
  }
}
