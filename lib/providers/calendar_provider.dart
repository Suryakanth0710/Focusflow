import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/event_model.dart';
import '../services/firestore_service.dart';

class CalendarProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService.instance;

  List<EventModel> events = [];
  StreamSubscription<List<EventModel>>? _sub;

  /// Subscribes to event stream for current user.
  void subscribe(String uid) {
    _sub?.cancel();
    _sub = _firestore.streamEvents(uid).listen((items) {
      events = items;
      notifyListeners();
    });
  }

  /// Creates or updates an event document.
  Future<void> save(String uid, EventModel event) => _firestore.upsertEvent(uid, event);

  /// Deletes event by id.
  Future<void> delete(String uid, String id) => _firestore.deleteEvent(uid, id);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
