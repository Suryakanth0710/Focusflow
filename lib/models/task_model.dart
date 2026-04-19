import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high }

class TaskModel {
  final String id;
  final String title;
  final DateTime dueDate;
  final TaskPriority priority;
  final String notes;
  final bool isCompleted;
  final bool syncToCalendar;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.notes,
    required this.isCompleted,
    required this.syncToCalendar,
  });

  TaskModel copyWith({
    String? title,
    DateTime? dueDate,
    TaskPriority? priority,
    String? notes,
    bool? isCompleted,
    bool? syncToCalendar,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      syncToCalendar: syncToCalendar ?? this.syncToCalendar,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'dueDate': Timestamp.fromDate(dueDate),
        'priority': priority.name,
        'notes': notes,
        'isCompleted': isCompleted,
        'syncToCalendar': syncToCalendar,
      };

  static TaskModel fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] as String,
        title: map['title'] as String,
        dueDate: (map['dueDate'] as Timestamp).toDate(),
        priority: TaskPriority.values.byName(map['priority'] as String),
        notes: (map['notes'] as String?) ?? '',
        isCompleted: (map['isCompleted'] as bool?) ?? false,
        syncToCalendar: (map['syncToCalendar'] as bool?) ?? false,
      );
}
