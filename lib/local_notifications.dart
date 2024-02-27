import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onClickNotication = BehaviorSubject<String>();
  // on tab notification
  static void onNotificationTab(NotificationResponse notificationResponse) {
    onClickNotication.add(notificationResponse.payload!);
  }

  static Future init() async {
    await loadMessages();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        // ignore: prefer_const_constructors
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTab,
        onDidReceiveBackgroundNotificationResponse: onNotificationTab);
  }

  static List<Map<String, dynamic>> messages = [];
  static Future loadMessages() async {
    String jsonData = await rootBundle.loadString('assets/images/tasks.json');
    messages = json.decode(jsonData).cast<Map<String, dynamic>>();
  }

// show scheduled notification
  static Future showScheduledNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    var localTime = tz.local;
  }

// show periodic notification
  static Future showPeriodicNotification() async {
    // Random random = Random();
    // int randomNumber = random.nextInt(messages.length);
    Map<String, dynamic> selectedMessage = messages[messages.length - 1];

    String title = selectedMessage['task'];
    String body = selectedMessage['message'];
    String payload = selectedMessage['task'];
    // String title = "hello";
    // String body = "body";
    // String payload = "payload";
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 2', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, RepeatInterval.everyMinute, notificationDetails,
        payload: payload);
  }

  // close the specific channe; notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifcation
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // pramo sir
  static Future<void> checkPendingNotificationRequests(
      BuildContext context) async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    // ignore: use_build_context_synchronously
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
            Text('${pendingNotificationRequests.length} pending notification '
                'requests'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// tz.TZDateTime _nextInstanceOfTenAM() {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduledDate =
//       tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
//   if (scheduledDate.isBefore(now)) {
//     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   }
//   return scheduledDate;
// }



// // sdfghjk
// await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'daily scheduled notification title',
//         'daily scheduled notification body',
//         _nextInstanceOfTenAM(),
//         const NotificationDetails(
//           android: AndroidNotificationDetails('daily notification channel id',
//               'daily notification channel name',
//               channelDescription: 'daily notification description'),
//         ),
//         // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time);