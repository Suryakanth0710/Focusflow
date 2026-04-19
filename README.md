# FocusFlow (Flutter + Firebase + Razorpay)

FocusFlow is a clean, minimal Apple-style productivity app MVP with Calendar, Tasks, and Profile tabs.

## Features
- Firebase Authentication (Email + Google Sign-In)
- Firestore per-user events/tasks/profile storage
- Calendar with month/week/day-strip modes, and event CRUD
- Tasks/reminders with completion and priority
- Local notifications and Firebase Cloud Messaging setup
- Razorpay premium checkout (India)
- Provider-based state management with modular services/models/providers/screens architecture

## Project Structure
```
lib/
  core/
    app_theme.dart
  models/
    event_model.dart
    task_model.dart
    user_profile.dart
  providers/
    auth_provider.dart
    calendar_provider.dart
    task_provider.dart
    premium_provider.dart
  screens/
    auth_gate.dart
    home_shell.dart
    calendar_screen.dart
    tasks_screen.dart
    profile_screen.dart
    widgets/
      event_editor_sheet.dart
      task_editor_sheet.dart
  services/
    auth_service.dart
    firestore_service.dart
    notification_service.dart
    fcm_service.dart
    razorpay_service.dart
  main.dart
```

## Setup Instructions

### 1) Flutter prerequisites
```bash
flutter --version
flutter pub get
```

### 2) Firebase setup
1. Create a Firebase project in Firebase Console.
2. Add Android (`com.example.focusflow`) and iOS bundle IDs.
3. Download and add:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Enable Authentication methods:
   - Email/Password
   - Google Sign-In
5. Create Firestore database in production/test mode.
6. Add Firestore rules (starter):

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

### 3) FCM setup
1. Enable Cloud Messaging in Firebase.
2. Android: configure notification channels and permissions in `AndroidManifest.xml`.
3. iOS: enable Push Notifications + Background Modes in Xcode.
4. Upload APNs key in Firebase (for iOS push).

### 4) Razorpay setup (India)
1. Create Razorpay account and get test/live keys.
2. Replace `rzp_test_replace_with_live_key` in `lib/services/razorpay_service.dart`.
3. Android:
   - Add internet permission and Razorpay proguard keep rules.
4. iOS:
   - Run `pod install` and ensure required URL schemes are configured.

### 5) Run
```bash
flutter pub get
flutter run
```

## Premium behavior
On successful Razorpay payment, `users/{uid}.isPremium` is set to true in Firestore and premium UI features are unlocked.

## Notes for production hardening
- Move payment verification to backend webhooks.
- Add server-side entitlement checks.
- Add robust notification scheduling and timezone handling.
- Add analytics dashboards and tests.
