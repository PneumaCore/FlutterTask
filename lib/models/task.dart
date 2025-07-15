class Task {
  final String id;
  String title;
  String description;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });
}
