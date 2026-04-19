import 'package:flutter/material.dart';

import '../../models/task_model.dart';

class TaskEditorSheet extends StatefulWidget {
  final TaskModel? initial;

  const TaskEditorSheet({super.key, this.initial});

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TaskPriority _priority = TaskPriority.medium;
  bool _syncToCalendar = false;

  @override
  void initState() {
    super.initState();
    final t = widget.initial;
    _title.text = t?.title ?? '';
    _notes.text = t?.notes ?? '';
    _dueDate = t?.dueDate ?? DateTime.now();
    _priority = t?.priority ?? TaskPriority.medium;
    _syncToCalendar = t?.syncToCalendar ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.initial == null ? 'New Task' : 'Edit Task', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 10),
          TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDate: _dueDate,
              );
              if (picked != null) setState(() => _dueDate = picked);
            },
            child: Text('Due ${_dueDate.year}-${_dueDate.month}-${_dueDate.day}'),
          ),
          const SizedBox(height: 8),
          SegmentedButton<TaskPriority>(
            segments: const [
              ButtonSegment(value: TaskPriority.low, label: Text('Low')),
              ButtonSegment(value: TaskPriority.medium, label: Text('Medium')),
              ButtonSegment(value: TaskPriority.high, label: Text('High')),
            ],
            selected: {_priority},
            onSelectionChanged: (s) => setState(() => _priority = s.first),
          ),
          SwitchListTile(
            value: _syncToCalendar,
            onChanged: (v) => setState(() => _syncToCalendar = v),
            title: const Text('Sync into calendar'),
            contentPadding: EdgeInsets.zero,
          ),
          FilledButton(
            onPressed: () {
              if (_title.text.trim().isEmpty) return;
              Navigator.pop(
                context,
                TaskModel(
                  id: widget.initial?.id ?? '',
                  title: _title.text.trim(),
                  dueDate: _dueDate,
                  priority: _priority,
                  notes: _notes.text.trim(),
                  isCompleted: widget.initial?.isCompleted ?? false,
                  syncToCalendar: _syncToCalendar,
                ),
              );
            },
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
