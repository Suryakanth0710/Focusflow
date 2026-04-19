import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int colorValue;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'startHour': startTime.hour,
        'startMinute': startTime.minute,
        'endHour': endTime.hour,
        'endMinute': endTime.minute,
        'colorValue': colorValue,
      };

  static EventModel fromMap(Map<String, dynamic> map) => EventModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: (map['description'] as String?) ?? '',
        date: (map['date'] as Timestamp).toDate(),
        startTime: TimeOfDay(
          hour: map['startHour'] as int,
          minute: map['startMinute'] as int,
        ),
        endTime: TimeOfDay(
          hour: map['endHour'] as int,
          minute: map['endMinute'] as int,
        ),
        colorValue: map['colorValue'] as int,
      );
}
