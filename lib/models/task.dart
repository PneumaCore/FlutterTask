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
}
