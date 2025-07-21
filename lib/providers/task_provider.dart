import 'package:flutter/material.dart';

import '../models/task.dart';

enum TaskFilter {
  all,
  completed,
  pending,
}
class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  List<Task> get tasks {
    switch (_filter) {
      case TaskFilter.completed:
        return _tasks.where((task) => task.isDone).toList();
      case TaskFilter.pending:
        return _tasks.where((task) => !task.isDone).toList();
      case TaskFilter.all:
      default:
        return [..._tasks];
    }
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  TaskFilter get filter => _filter;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleStatus(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isDone = !task.isDone;
    notifyListeners();
  }
}
