import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

enum SortType { creationDateAsc, creationDateDesc, deadlineAsc, deadlineDesc }

enum TaskFilter { all, completed, pending }

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';
  SortType _sortType = SortType.creationDateDesc;

  TaskProvider() {
    _init();
  }

  TaskFilter get filter => _filter;

  SortType get sortType => _sortType;

  // Getter for search query.
  List<Task> get tasks {
    List<Task> filtered = [];

    // Apply sorting based on the current sort type.
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

  // Getter for the number of tasks.
  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  // Method to delete a task by its ID.
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    saveTasks();
    notifyListeners();
  }

  // Method to load tasks from SharedPreferences.
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      final List<dynamic> decoded = jsonDecode(tasksString);
      _tasks = decoded.map((item) => Task.fromMap(item)).toList();
      notifyListeners();
    }
  }

  // Method to save tasks to SharedPreferences.
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = jsonEncode(_tasks.map((t) => t.toMap()).toList());
    await prefs.setString('tasks', tasksString);
  }

  // Method to set the filter type.
  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  // Method to set the search query.
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  // Method to set the sort type.
  void setSortType(SortType type) {
    _sortType = type;
    _sortTasks();
    notifyListeners();
  }

  // Method to toggle the status of a task by its ID.
  void toggleStatus(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isDone = !task.isDone;
    saveTasks();
    notifyListeners();
  }

  // Method to update a task by its ID.
  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      saveTasks();
      notifyListeners();
    }
  }

  // Method to initialize the provider.
  Future<void> _init() async {
    await loadTasks();
    notifyListeners();
  }

  // Method to sort tasks based on the current sort type.
  void _sortTasks() {
    switch (_sortType) {
      case SortType.creationDateAsc:
        _tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortType.creationDateDesc:
        _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortType.deadlineAsc:
        _tasks.sort((a, b) {
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });
        break;
      case SortType.deadlineDesc:
        _tasks.sort((a, b) {
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return b.deadline!.compareTo(a.deadline!);
        });
        break;
    }
  }
}
