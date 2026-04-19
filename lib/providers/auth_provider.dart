import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _auth = AuthService.instance;
  final FirestoreService _firestore = FirestoreService.instance;

  StreamSubscription<User?>? _sub;
  User? user;
  bool loading = true;
  String? error;

  /// Starts listening to Firebase authentication state.
  void bootstrap() {
    _sub = _auth.userChanges.listen((u) async {
      user = u;
      if (u != null) {
        await _firestore.saveUserProfile(
          UserProfile(uid: u.uid, email: u.email, name: u.displayName, isPremium: false),
        );
      }
      loading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    error = null;
    try {
      await _auth.signInWithEmail(email, password);
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    error = null;
    try {
      await _auth.signUpWithEmail(email, password);
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    error = null;
    try {
      await _auth.signInWithGoogle();
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signOut() => _auth.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
