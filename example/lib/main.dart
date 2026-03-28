import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:adaptive_core_flutter/adaptive_core_flutter.dart';
import 'package:adaptive_messaging_flutter/adaptive_messaging_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Messaging Example',
      theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _ready = false;
  String _status = 'Not ready — initialize and login first.';

  // A sample Adaptive notification payload.
  final String _samplePayload = jsonEncode({
    'source': 'adaptive',
    'title': 'New Grade Posted',
    'description': 'Your grade for "Flutter Basics" has been updated.',
  });

  Future<void> _setup() async {
    try {
      await AdaptiveCore.initialize(clientId: 'YOUR_CLIENT_ID', debug: true);
      await AdaptiveCore.login(
        const AdaptiveUser(
            userId: '1001',
            userName: 'Jane Doe',
            userEmail: 'jane@example.com'),
      );
      setState(() {
        _ready = true;
        _status = '✅ Ready';
      });
    } on AdaptiveException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _registerToken() async {
    // In production use FirebaseMessaging.instance.getToken()
    const fakeToken = 'FAKE_FCM_TOKEN_FOR_DEMO';
    try {
      await AdaptiveMessaging.setFCMToken(fakeToken);
      setState(() => _status = '✅ FCM token registered');
    } on AdaptiveMessagingException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _checkNotification() async {
    try {
      final isAdaptive =
          await AdaptiveMessaging.isAdaptiveNotification(_samplePayload);
      setState(
          () => _status = isAdaptive ? '✅ Is Adaptive notification' : '⚠️ Not Adaptive');
    } on AdaptiveMessagingException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  Future<void> _showNotification() async {
    try {
      await AdaptiveMessaging.showAdaptiveNotification(_samplePayload);
      setState(() => _status = '✅ Notification shown');
    } on AdaptiveMessagingException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Messaging Example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: _ready ? null : _setup,
                child: const Text('Initialize & Login')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _ready ? _registerToken : null,
                child: const Text('Register FCM Token')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _ready ? _checkNotification : null,
                child: const Text('Is Adaptive Notification?')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _ready ? _showNotification : null,
                child: const Text('Show Adaptive Notification')),
          ],
        ),
      ),
    );
  }
}
