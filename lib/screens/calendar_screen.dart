import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../models/event_model.dart';
import '../providers/auth_provider.dart';
import '../providers/calendar_provider.dart';
import '../services/notification_service.dart';
import 'widgets/event_editor_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().user!.uid;
    final provider = context.watch<CalendarProvider>();
    final dayEvents = provider.events.where((e) => isSameDay(e.date, _selected)).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Calendar', style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => _openEditor(context, uid),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TableCalendar<EventModel>(
                  focusedDay: _focused,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2100),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.twoWeeks: 'Week',
                    CalendarFormat.week: 'Day strip',
                  },
                  selectedDayPredicate: (day) => isSameDay(day, _selected),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selected = selectedDay;
                      _focused = focusedDay;
                    });
                  },
                  calendarFormat: _format,
                  onFormatChanged: (f) => setState(() => _format = f),
                  eventLoader: (day) => provider.events.where((e) => isSameDay(e.date, day)).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: dayEvents.length,
                itemBuilder: (_, i) {
                  final event = dayEvents[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: event.color),
                      title: Text(event.title),
                      subtitle: Text('${event.startTime.format(context)} - ${event.endTime.format(context)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openEditor(context, uid, existing: event),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => provider.delete(uid, event.id),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 250.ms).slideY(begin: .1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens event form in bottom sheet and saves event to Firestore.
  Future<void> _openEditor(BuildContext context, String uid, {EventModel? existing}) async {
    final data = await showModalBottomSheet<EventModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EventEditorSheet(initial: existing, selectedDate: _selected),
    );

    if (data != null && mounted) {
      final event = existing == null ? data.copyWithId(const Uuid().v4()) : data;
      await context.read<CalendarProvider>().save(uid, event);
      await NotificationService.instance.showReminder(
        id: event.id.hashCode,
        title: 'Event saved',
        body: event.title,
      );
    }
  }
}

extension _EventModelX on EventModel {
  EventModel copyWithId(String newId) {
    return EventModel(
      id: newId,
      title: title,
      description: description,
      date: date,
      startTime: startTime,
      endTime: endTime,
      colorValue: colorValue,
    );
  }
}
