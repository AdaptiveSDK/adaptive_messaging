# adaptive_messaging

[![pub version](https://img.shields.io/pub/v/adaptive_messaging.svg)](https://pub.dev/packages/adaptive_messaging)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform Android](https://img.shields.io/badge/platform-android-green.svg)](https://pub.dev/packages/adaptive_messaging)
[![Platform iOS](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://pub.dev/packages/adaptive_messaging)

Flutter plugin for the **Adaptive SDK Messaging** module. Handles push notifications for the Adaptive e-learning platform:

- 📲 **Register FCM tokens** with the Adaptive backend
- 🔍 **Detect Adaptive notifications** from incoming FCM payloads
- 🔔 **Display in-app system notifications** via an Android notification channel

> **Requires** [`adaptive_core`](https://pub.dev/packages/adaptive_core) to be initialized first.  
> Supports **Android** and **iOS**. Notifications use the `adaptive_channel` notification channel on Android.

---

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Android Setup](#android-setup)
- [Usage](#usage)
  - [1. Initialize Core SDK](#1-initialize-core-sdk)
  - [2. Register FCM Token](#2-register-fcm-token)
  - [3. Handle Incoming Messages](#3-handle-incoming-messages)
- [Full FCM Integration Example](#full-fcm-integration-example)
- [Error Handling](#error-handling)
- [API Reference](#api-reference)
- [Notification Payload Format](#notification-payload-format)
- [Contributing](#contributing)
- [License](#license)

---

## Requirements

| Requirement | Minimum Version |
|-------------|----------------|
| Flutter | 3.10.0 |
| Dart | 3.0.0 |
| Android `minSdk` | 24 (Android 7.0) |
| Android `compileSdk` | 35 |
| iOS minimum | 15.0 |
| `adaptive_core` | 1.0.0 |

---

## Installation

```yaml
dependencies:
  adaptive_core: ^1.0.0
  adaptive_messaging: ^1.0.0
```

```bash
flutter pub get
```

---

## Android Setup

### 1. Internet permission

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. Notification permission (Android 13+)

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

Request the permission at runtime before calling `showAdaptiveNotification`:

```dart
// Using permission_handler package
await Permission.notification.request();
```

---

## Usage

### 1. Initialize Core SDK

```dart
import 'package:adaptive_core/adaptive_core.dart';
import 'package:adaptive_messaging/adaptive_messaging.dart';

await AdaptiveCore.initialize(clientId: 'YOUR_API_KEY');
await AdaptiveCore.login(
  const AdaptiveUser(
    userId: '1001',
    userName: 'Jane Doe',
    userEmail: 'jane@example.com',
  ),
);
```

### 2. Register FCM Token

Register the device's FCM token so the Adaptive backend can target this device:

```dart
// Call once after login, and every time the token refreshes:
await AdaptiveMessaging.setFCMToken(fcmToken);
```

### 3. Handle Incoming Messages

When your FCM handler receives a message, check if it's from Adaptive and display it:

```dart
import 'dart:convert';

final payload = jsonEncode(message.data); // Convert FCM data map to JSON string

final isAdaptive = await AdaptiveMessaging.isAdaptiveNotification(payload);

if (isAdaptive) {
  await AdaptiveMessaging.showAdaptiveNotification(payload);
}
```

---

## Full FCM Integration Example

```dart
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:adaptive_core/adaptive_core.dart';
import 'package:adaptive_messaging/adaptive_messaging.dart';

Future<void> initAdaptive() async {
  // 1. Initialize and login
  await AdaptiveCore.initialize(clientId: 'YOUR_API_KEY');
  await AdaptiveCore.login(
    const AdaptiveUser(
      userId: '1001',
      userName: 'Jane Doe',
      userEmail: 'jane@example.com',
    ),
  );

  // 2. Register FCM token
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await AdaptiveMessaging.setFCMToken(token);
  }

  // 3. Keep token fresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    AdaptiveMessaging.setFCMToken(newToken);
  });

  // 4. Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final payload = jsonEncode(message.data);
    if (await AdaptiveMessaging.isAdaptiveNotification(payload)) {
      await AdaptiveMessaging.showAdaptiveNotification(payload);
    }
  });
}
```

---

## Error Handling

```dart
try {
  await AdaptiveMessaging.setFCMToken(token);
} on AdaptiveMessagingException catch (e) {
  print('Messaging error [${e.code}]: ${e.message}');
}
```

### Error codes

| Code | Cause |
|------|-------|
| `FCM_ERROR` | Failed to register FCM token (e.g. user not logged in) |
| `NOTIFICATION_CHECK_ERROR` | Failed to parse or check the payload |
| `SHOW_NOTIFICATION_ERROR` | Failed to display the notification |
| `INVALID_ARGUMENT` | A required argument was null or missing |

---

## API Reference

### `AdaptiveMessaging`

| Method | Returns | Description |
|--------|---------|-------------|
| `setFCMToken(String token)` | `Future<void>` | Registers the FCM token with the Adaptive backend |
| `isAdaptiveNotification(String payload)` | `Future<bool>` | Returns `true` if the JSON payload contains `"source": "adaptive"` |
| `showAdaptiveNotification(String payload)` | `Future<void>` | Parses and displays a system notification |

---

## Notification Payload Format

The `payload` parameter is a **JSON string** (not a Dart `Map`). The Adaptive backend sends the following structure:

```json
{
  "source": "adaptive",
  "title": "New Grade Posted",
  "description": "Your grade for 'Flutter Basics' has been updated to 85/100."
}
```

| Key | Required | Description |
|-----|----------|-------------|
| `source` | ✅ | Must be `"adaptive"` (case-insensitive) for `isAdaptiveNotification` to return `true` |
| `title` | ✅ | Notification title shown in the system tray |
| `description` | ✅ | Notification body text |

---

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit: `git commit -m 'feat: add my feature'`
4. Push: `git push origin feature/my-feature`
5. Open a Pull Request

---

## License

MIT License — see [LICENSE](LICENSE) for details.
