import 'package:flutter/material.dart';

import '../../models/event_model.dart';

class EventEditorSheet extends StatefulWidget {
  final EventModel? initial;
  final DateTime selectedDate;

  const EventEditorSheet({super.key, this.initial, required this.selectedDate});

  @override
  State<EventEditorSheet> createState() => _EventEditorSheetState();
}

class _EventEditorSheetState extends State<EventEditorSheet> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  late DateTime _date;
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);
  Color _color = const Color(0xFF2D6CDF);

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    _date = e?.date ?? widget.selectedDate;
    _title.text = e?.title ?? '';
    _desc.text = e?.description ?? '';
    _start = e?.startTime ?? _start;
    _end = e?.endTime ?? _end;
    _color = e?.color ?? _color;
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
          Text(widget.initial == null ? 'New Event' : 'Edit Event', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 10),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: _date,
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: Text('${_date.year}-${_date.month}-${_date.day}'),
              ),
            ),
          ]),
          Row(children: [
            Expanded(child: _timeButton(context, 'Start', _start, (v) => setState(() => _start = v))),
            const SizedBox(width: 8),
            Expanded(child: _timeButton(context, 'End', _end, (v) => setState(() => _end = v))),
          ]),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final color in [Colors.blue, Colors.green, Colors.orange, Colors.purple])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text(''),
                    selected: _color == color,
                    onSelected: (_) => setState(() => _color = color),
                    avatar: CircleAvatar(backgroundColor: color),
                  ),
                )
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (_title.text.trim().isEmpty) return;
              Navigator.pop(
                context,
                EventModel(
                  id: widget.initial?.id ?? '',
                  title: _title.text.trim(),
                  description: _desc.text.trim(),
                  date: _date,
                  startTime: _start,
                  endTime: _end,
                  colorValue: _color.value,
                ),
              );
            },
            child: const Text('Save Event'),
          ),
        ],
      ),
    );
  }

  /// Reusable time picker button.
  Widget _timeButton(BuildContext context, String label, TimeOfDay value, ValueChanged<TimeOfDay> onPick) {
    return OutlinedButton(
      onPressed: () async {
        final picked = await showTimePicker(context: context, initialTime: value);
        if (picked != null) onPick(picked);
      },
      child: Text('$label ${value.format(context)}'),
    );
  }
}
