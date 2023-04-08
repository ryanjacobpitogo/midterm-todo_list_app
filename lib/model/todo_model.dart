import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  String label;
  String desc;
  bool isCompleted;

  Todo({
    required this.label,
    this.desc = '',
    required this.isCompleted,
  }) : id = const Uuid().v4();

  void checked() {
    isCompleted = true;
  }

  @override
  bool operator ==(covariant Todo other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}