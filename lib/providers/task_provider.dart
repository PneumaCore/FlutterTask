import 'package:flutter/material.dart';

import '../models/task.dart';

enum TaskFilter { all, completed, pending }

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';

  TaskFilter get filter => _filter;

  List<Task> get tasks {
    List<Task> filtered = [];

    switch (_filter) {
      case TaskFilter.all:
        filtered = [..._tasks];
      case TaskFilter.completed:
        filtered = _tasks.where((task) => task.isDone).toList();
        break;
      case TaskFilter.pending:
        filtered = _tasks.where((task) => !task.isDone).toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery) ||
            task.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void toggleStatus(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
