import 'package:flutter/services.dart';
import 'adaptive_messaging_exception.dart';

/// Manages push-notification functionality for the Adaptive platform.
///
/// Requires [AdaptiveCore] to be initialized and a user logged in.
///
/// Typical FCM integration:
/// ```dart
/// FirebaseMessaging.instance.getToken().then((token) {
///   if (token != null) AdaptiveMessaging.setFCMToken(token);
/// });
///
/// FirebaseMessaging.onMessage.listen((message) {
///   final payload = jsonEncode(message.data);
///   if (AdaptiveMessaging.isAdaptiveNotification(payload)) {
///     AdaptiveMessaging.showAdaptiveNotification(payload);
///   }
/// });
/// ```
class AdaptiveMessaging {
  static const MethodChannel _channel = MethodChannel('adaptive_messaging');

  AdaptiveMessaging._();

  /// Registers the device FCM [token] with the Adaptive backend.
  ///
  /// Call this whenever `FirebaseMessaging.instance.onTokenRefresh` fires or
  /// when you first retrieve a token.
  ///
  /// Throws [AdaptiveMessagingException] on failure.
  static Future<void> setFCMToken(String token) async {
    try {
      await _channel.invokeMethod<void>('setFCMToken', {'token': token});
    } on PlatformException catch (e) {
      throw AdaptiveMessagingException(code: e.code, message: e.message ?? '');
    }
  }

  /// Returns `true` if [payload] is an Adaptive push-notification.
  ///
  /// Checks whether the JSON payload contains `"source": "adaptive"` (case-
  /// insensitive). Use this to filter incoming FCM messages.
  ///
  /// Throws [AdaptiveMessagingException] on failure.
  static Future<bool> isAdaptiveNotification(String payload) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isAdaptiveNotification',
        {'payload': payload},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw AdaptiveMessagingException(code: e.code, message: e.message ?? '');
    }
  }

  /// Parses [payload] and displays a system notification via the
  /// `adaptive_channel` notification channel.
  ///
  /// The payload must contain `title` and `description` (or `body`) keys.
  /// Requires the `POST_NOTIFICATIONS` permission on Android 13+.
  ///
  /// Throws [AdaptiveMessagingException] on failure.
  static Future<void> showAdaptiveNotification(String payload) async {
    try {
      await _channel.invokeMethod<void>('showAdaptiveNotification', {
        'payload': payload,
      });
    } on PlatformException catch (e) {
      throw AdaptiveMessagingException(code: e.code, message: e.message ?? '');
    }
  }
}
