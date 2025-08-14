class Task {
  final String id;
  String title;
  String description;
  bool isDone;
  final DateTime createdAt;
  DateTime? deadline;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    required this.createdAt,
    this.deadline,
  });

  // Factory method to create a Task from a map.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
      createdAt: DateTime.parse(map['createdAt']),
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'])
          : null,
    );
  }

  // Method to convert a Task to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
    };
  }
}
