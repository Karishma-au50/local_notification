import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pramo/another_page.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the plugin with proper settings for Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        default:
          break;
      }
    },
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const MyApp(this.flutterLocalNotificationsPlugin, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      home: HomePage(flutterLocalNotificationsPlugin),
    );
  }
}

class HomePage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const HomePage(this.flutterLocalNotificationsPlugin, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => const AnotherPage(payload: "abcgvh"),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    configureSelectNotificationSubject();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _scheduleNotification();
          },
          child: const Text('Schedule Notification'),
        ),
      ),
    );
  }

// vibration
  Future<void> _scheduleNotification() async {
    // Cancel all previously scheduled notifications
    await widget.flutterLocalNotificationsPlugin.cancelAll();

    // Schedule 16 notifications at specific times
    for (int i = 1; i <= 16; i++) {
      await widget.flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        'Notification $i',
        'This is notification $i',
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        _nextInstanceOfSpecificTime(i),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            // 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent:
                true, // Display notification as heads-up notification
            enableVibration: true, // Enable vibration
            vibrationPattern:
                Int64List.fromList([0, 1000, 500, 1000]), // Vibration pattern
          ),
        ),
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  // Future<void> _scheduleNotification() async {
  tz.TZDateTime _nextInstanceOfSpecificTime(int index) {
    var localTime = tz.local;
    final now = tz.TZDateTime.now(localTime);
    final scheduledDate =
        now.add(Duration(minutes: 1 * index)); // Schedule every minute
    return scheduledDate;
  }
}
