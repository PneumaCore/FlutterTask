import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).setFilter(filter);
            },
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              const PopupMenuItem(value: TaskFilter.all, child: Text('All')),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
              const PopupMenuItem(
                value: TaskFilter.pending,
                child: Text('Pending'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('There are no tasks yet.'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Dismissible(
                        key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          taskProvider.deleteTask(task.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task "${task.title}" deleted.'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  taskProvider.addTask(task);
                                },
                              ),
                            ),
                          );
                        },
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (task.deadline != null)
                                Text(
                                  'Deadline: ${DateFormat('dd-MM-yyyy').format(task.deadline!)}',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                            ],
                          ),
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) {
                              taskProvider.toggleStatus(task.id);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TaskFormScreen(existingTask: task),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
