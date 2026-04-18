## 1.0.22

* Bumped iOS `AdaptiveMessaging` CocoaPod dependency pin to `~> 1.0.22`.
* Bumped Android native dependency pin to `adaptive-messaging:1.0.22`.

## 1.0.21

* Bumped iOS `AdaptiveMessaging` CocoaPod dependency pin to `~> 1.0.21`.
* Bumped Android native dependency pin to `adaptive-messaging:1.0.21`.

## 1.0.20

* Bumped iOS `AdaptiveMessaging` CocoaPod dependency pin to `~> 1.0.20`.
* Bumped Android native dependency pin to `adaptive-messaging:1.0.20`.

## 1.0.19

* Bumped iOS `AdaptiveMessaging` CocoaPod dependency pin to `~> 1.0.19`.
* Bumped Android native dependency pin to `adaptive-messaging:1.0.19`.

## 1.0.12

* **`AdaptiveMessaging.showAdaptiveNotification`** – notification title and
  description are now extracted from a nested `notification` object inside the
  FCM data payload (`data → notification → title / description`) when present,
  falling back to the flat `data.title` / `data.description` fields. Both
  payload shapes are supported with no changes required by the consumer.
* **Android** – `InternalHttpClient` now logs a structured `→ REQUEST` /
  `← RESPONSE` block for every HTTP call. Gated by debug mode.
* **Android** – removed `mavenLocal()` from plugin build configuration.
* Bumped Android native dependency pin to `adaptive-messaging:1.0.11`.
* Bumped iOS `AdaptiveMessaging` CocoaPod dependency pin to `~> 1.0.12`.

## 1.0.8

* Moved iOS podspec to `ios/` directory (standard Flutter plugin layout).
* Fixed podspec `source_files` path and `license` reference.
* Split `Initialize` and `Login` into separate buttons in the example app.
* Fixed `MethodChannel` declaration to use `const` constructor.
* Sorted `dev_dependencies` alphabetically in `pubspec.yaml`.

## 1.0.7

* Minor improvements to Android build configuration.

## 1.0.6

* Added iOS platform support (iOS 15.0+).
* Fixed README package name references to use correct pub.dev package names.

## 1.0.0

* Initial release.
* `AdaptiveMessaging.setFCMToken` — register a device FCM token with the Adaptive backend.
* `AdaptiveMessaging.isAdaptiveNotification` — detect Adaptive push notification payloads.
* `AdaptiveMessaging.showAdaptiveNotification` — display Adaptive system notifications via the `adaptive_channel` notification channel.