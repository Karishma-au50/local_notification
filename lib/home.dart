import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pramo/another_page.dart';
import 'package:pramo/local_notifications.dart';
import 'package:pramo/pramoMethod.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  // to listen notification clicke dor not
  listenToNotifications() {
    print("listen to notifictaion");
    LocalNotification.onClickNotication.stream.listen((event) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AnotherPage(payload: event)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("flutter notification"),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
              onPressed: () {
                // LocalNotification.showScheduled();
                LocalNotification.showScheduledNotification(
                    title: "hello periodic notification",
                    body: "body",
                    payload: "payload simple data");
                // NotificationService().repeatNotification(
                //   0,
                //   'Hello World!',
                //   'Welcome to Hello World!',
                //   {'name': 'Hello World!'},
                //   RepeatInterval.everyMinute,
                // );
              },
              icon: const Icon(Icons.timer_outlined),
              // label: const Text("periodic notification")
              label: const Text("scheduleed notification")),
          // close periodic notifictaion
          // TextButton(
          //     onPressed: () {
          //       LocalNotification.cancel(1);
          //       // LocalNotification.cancelAll();
          //     },
          //     child: const Text("close periodic notification")),
          TextButton(
              onPressed: () {
                LocalNotification.checkPendingNotificationRequests(context);
              },
              child: const Text("pending task")),
          TextButton(
              onPressed: () {
                LocalNotification.cancelAll();
              },
              child: const Text("cancel all"))
        ],
      ),
    );
  }
}
