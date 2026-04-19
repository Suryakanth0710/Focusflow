import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  /// Requests notification permissions and configures foreground behavior.
  Future<void> init() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
