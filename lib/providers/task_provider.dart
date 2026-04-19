import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../services/firestore_service.dart';

class TaskProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService.instance;

  List<TaskModel> tasks = [];
  StreamSubscription<List<TaskModel>>? _sub;

  /// Subscribes to task stream for current user.
  void subscribe(String uid) {
    _sub?.cancel();
    _sub = _firestore.streamTasks(uid).listen((items) {
      tasks = items;
      notifyListeners();
    });
  }

  List<TaskModel> get pending => tasks.where((t) => !t.isCompleted).toList();
  List<TaskModel> get completed => tasks.where((t) => t.isCompleted).toList();

  /// Creates or updates a task document.
  Future<void> save(String uid, TaskModel task) => _firestore.upsertTask(uid, task);

  /// Toggles task completion state.
  Future<void> toggleComplete(String uid, TaskModel task) {
    return save(uid, task.copyWith(isCompleted: !task.isCompleted));
  }

  /// Deletes task by id.
  Future<void> delete(String uid, String id) => _firestore.deleteTask(uid, id);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
