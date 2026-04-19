import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';
import '../models/task_model.dart';
import '../models/user_profile.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userDoc(String uid, String key) {
    return _db.collection('users').doc(uid).collection(key);
  }

  Future<void> saveUserProfile(UserProfile profile) {
    return _db.collection('users').doc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  Stream<UserProfile> userProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (doc) => UserProfile.fromMap(doc.data() ?? {'uid': uid, 'isPremium': false}),
        );
  }

  Stream<List<EventModel>> streamEvents(String uid) {
    return _userDoc(uid, 'events').orderBy('date').snapshots().map(
          (snap) => snap.docs.map((d) => EventModel.fromMap(d.data())).toList(),
        );
  }

  Future<void> upsertEvent(String uid, EventModel event) {
    return _userDoc(uid, 'events').doc(event.id).set(event.toMap());
  }

  Future<void> deleteEvent(String uid, String id) {
    return _userDoc(uid, 'events').doc(id).delete();
  }

  Stream<List<TaskModel>> streamTasks(String uid) {
    return _userDoc(uid, 'tasks').orderBy('dueDate').snapshots().map(
          (snap) => snap.docs.map((d) => TaskModel.fromMap(d.data())).toList(),
        );
  }

  Future<void> upsertTask(String uid, TaskModel task) {
    return _userDoc(uid, 'tasks').doc(task.id).set(task.toMap());
  }

  Future<void> deleteTask(String uid, String id) {
    return _userDoc(uid, 'tasks').doc(id).delete();
  }

  Future<void> setPremium(String uid, bool isPremium) {
    return _db.collection('users').doc(uid).set({'isPremium': isPremium}, SetOptions(merge: true));
  }
}
