import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
          PopupMenuButton<String>(
            onSelected: (value) {
              final taskProvider = Provider.of<TaskProvider>(
                context,
                listen: false,
              );
              if (value.startsWith('filter_')) {
                final filter =
                    TaskFilter.values[int.parse(value.split('_')[1])];
                taskProvider.setFilter(filter);
              } else if (value.startsWith('sort_')) {
                final sort = SortType.values[int.parse(value.split('_')[1])];
                taskProvider.setSortType(sort);
              }
            },
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  '--- Filter Tasks ---',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuItem(value: 'filter_0', child: Text('All')),
              const PopupMenuItem(value: 'filter_1', child: Text('Completed')),
              const PopupMenuItem(value: 'filter_2', child: Text('Pending')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  '--- Order Tasks ---',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuItem(
                value: 'sort_0',
                child: Text('Creation (recent)'),
              ),
              const PopupMenuItem(
                value: 'sort_1',
                child: Text('Creation (oldest)'),
              ),
              const PopupMenuItem(
                value: 'sort_2',
                child: Text('Deadline (nearby)'),
              ),
              const PopupMenuItem(
                value: 'sort_3',
                child: Text('Deadline (distant)'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total: ${taskProvider.tasks.length} | Pending: ${taskProvider.tasks.where((t) => !t.isDone).length} | Completed: ${taskProvider.tasks.where((t) => t.isDone).length}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: taskProvider.tasks
                              .where((t) => t.isDone)
                              .length
                              .toDouble(),
                          color:
                              (taskProvider.tasks.isNotEmpty &&
                                  taskProvider.tasks
                                          .where((t) => t.isDone)
                                          .length ==
                                      taskProvider.tasks.length)
                              ? Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFF43A047)
                              : Theme.of(context).colorScheme.secondary,
                          title: '',
                          radius: 55,
                        ),
                        PieChartSectionData(
                          value:
                              (taskProvider.tasks.length -
                                      taskProvider.tasks
                                          .where((t) => t.isDone)
                                          .length)
                                  .toDouble(),
                          color: Theme.of(context).colorScheme.surface,
                          title: '',
                          radius: 55,
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 45,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: taskProvider.tasks.isEmpty
                          ? 0
                          : (taskProvider.tasks.where((t) => t.isDone).length /
                                    taskProvider.tasks.length) *
                                100,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${value.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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
                              Text(
                                task.deadline != null
                                    ? 'Deadline: ${DateFormat('d MMMM, yyyy', 'en_US').format(task.deadline!)}.'
                                    : 'No deadline set.',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontStyle: task.deadline == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
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
