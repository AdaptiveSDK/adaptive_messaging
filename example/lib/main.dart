import 'dart:convert';

import 'package:adaptive_core/adaptive_core.dart';
import 'package:adaptive_messaging/adaptive_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

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
  bool _ready = true;
  String _status = 'Not ready — initialize and login first.';

  final String _samplePayload = jsonEncode({
    'source': 'adaptive',
    'title': 'New Grade Posted',
    'description': 'Your grade for "Flutter Basics" has been updated.',
  });

  Future<void> _setup() async {
    try {
      await AdaptiveCore.initialize(clientId: 'YOUR_CLIENT_ID', debug: true);
      setState(() {
        _ready = true;
        _status = '✅ Ready';
      });
    } on AdaptiveException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
    }
  }

  Future<void> _login() async {
    try {
      await AdaptiveCore.login(
        const AdaptiveUser(
          userId: '1001',
          userName: 'Jane Doe',
          userEmail: 'jane@example.com',
        ),
      );
      setState(() {
        _ready = true;
        _status = '✅ Ready';
      });
    } on AdaptiveException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
    }
  }

  Future<void> _registerToken() async {
    const fakeToken = 'FAKE_FCM_TOKEN_FOR_DEMO';
    try {
      await AdaptiveMessaging.setFCMToken(fakeToken);
      setState(() => _status = '✅ FCM token registered');
    } on AdaptiveMessagingException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
    }
  }

  Future<void> _checkNotification() async {
    try {
      final isAdaptive =
          await AdaptiveMessaging.isAdaptiveNotification(_samplePayload);
      setState(() => _status =
          isAdaptive ? '✅ Is Adaptive notification' : '⚠️ Not Adaptive');
    } on AdaptiveMessagingException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
    }
  }

  Future<void> _showNotification() async {
     await Permission.notification.request();


    try {
      await AdaptiveMessaging.showAdaptiveNotification(_samplePayload);
      setState(() => _status = '✅ Notification shown');
    } on AdaptiveMessagingException catch (e) {
      setState(() => _status = '❌ ${e.message}');
    } catch (e) {
      setState(() => _status = '❌ $e');
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Sample payload:\n$_samplePayload',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _ready ? _setup : null,
              icon: const Icon(Icons.rocket_launch),
              label: const Text('Initialize'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _ready ? _login : null,
              icon: const Icon(Icons.rocket_launch),
              label: const Text('Login'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _ready ? _registerToken : null,
              icon: const Icon(Icons.token),
              label: const Text('Register FCM Token'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _ready ? _checkNotification : null,
              icon: const Icon(Icons.search),
              label: const Text('Is Adaptive Notification?'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _ready ? _showNotification : null,
              icon: const Icon(Icons.notifications),
              label: const Text('Show Adaptive Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
