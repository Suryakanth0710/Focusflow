import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/task_model.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../services/notification_service.dart';
import 'widgets/task_editor_sheet.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().user!.uid;
    final provider = context.watch<TaskProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Tasks', style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => _openEditor(context, uid),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
            _Section(title: 'Pending (${provider.pending.length})', tasks: provider.pending, uid: uid),
            const SizedBox(height: 12),
            _Section(title: 'Completed (${provider.completed.length})', tasks: provider.completed, uid: uid),
          ],
        ),
      ),
    );
  }

  /// Opens task form and stores result in Firestore.
  Future<void> _openEditor(BuildContext context, String uid, {TaskModel? existing}) async {
    final data = await showModalBottomSheet<TaskModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(initial: existing),
    );

    if (data != null && context.mounted) {
      final task = existing == null
          ? data.copyWithWithId(const Uuid().v4())
          : data;
      await context.read<TaskProvider>().save(uid, task);
      await NotificationService.instance.showReminder(
        id: task.id.hashCode,
        title: 'Task saved',
        body: task.title,
      );
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<TaskModel> tasks;
  final String uid;

  const _Section({required this.title, required this.tasks, required this.uid});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    final task = tasks[i];
                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => provider.toggleComplete(uid, task),
                      ),
                      title: Text(task.title),
                      subtitle: Text('${task.priority.name.toUpperCase()} • ${task.dueDate.toLocal()}'.split(' ').first),
                      trailing: IconButton(
                        onPressed: () => provider.delete(uid, task.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.05);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _TaskModelX on TaskModel {
  TaskModel copyWithWithId(String newId) {
    return TaskModel(
      id: newId,
      title: title,
      dueDate: dueDate,
      priority: priority,
      notes: notes,
      isCompleted: isCompleted,
      syncToCalendar: syncToCalendar,
    );
  }
}
