import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _singleton = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal() {
    _initialize();
  }

  void _initialize() {
    // Initialize TZDateTime

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            ((NotificationResponse notificationResponse) {
      _handleNotificationResponse(notificationResponse);
    }));
  }

  void _handleNotificationResponse(NotificationResponse notificationResponse) {
    // Handle notification response here
    print('Received notification response');
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledDate,
    String time,
    dynamic payload,
    Function() onTimeExceeded,
  ) async {
    String channelID = 'time_channel_ID';
    String channelName = 'time_channel_name';
    int notificationID = id; // Use a unique ID for each notification.
    const channelDescription = 'focus mode notification based on time';

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelID,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.low,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationID,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode(payload), // payload needs to be string
    );

    // Calculate the delay to perform the action using timer.
    final delay =
        scheduledDate.difference(tz.TZDateTime.now(tz.local)).inMilliseconds;
    Timer(Duration(milliseconds: delay), onTimeExceeded);
  }

  Future<void> cancelNotification(int notificationID) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationID);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    dynamic payload,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'billo',
      'Ajuba',
      //  'your channel description',
      channelDescription: 'Ajuba Billo',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  // repeat notification
  Future<void> repeatNotification(
    int id,
    String title,
    String body,
    dynamic payload,
    RepeatInterval interval,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'billo',
      'Ajuba',
      //  'your channel description',
      channelDescription: 'Ajuba Billo',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      interval,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  // display notification
  Future<void> displayNotification(
    int id,
    String title,
    String body,
    dynamic payload,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'billo',
      'Ajuba',
      //  'your channel description',
      channelDescription: 'Ajuba Billo',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }
}
