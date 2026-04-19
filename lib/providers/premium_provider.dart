import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/firestore_service.dart';

class PremiumProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService.instance;
  StreamSubscription? _sub;
  bool isPremium = false;

  /// Subscribes to premium state in Firestore user profile.
  void subscribe(String uid) {
    _sub?.cancel();
    _sub = _firestore.userProfile(uid).listen((profile) {
      isPremium = profile.isPremium;
      notifyListeners();
    });
  }

  /// Sets premium status after payment completion.
  Future<void> setPremium(String uid, bool value) => _firestore.setPremium(uid, value);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
