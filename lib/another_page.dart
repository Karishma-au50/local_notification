import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnotherPage extends StatefulWidget {
  final String payload;
  const AnotherPage({super.key, required this.payload});
  @override
  State<AnotherPage> createState() => _AnotherPage();
}

class _AnotherPage extends State<AnotherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("another page"),
        ),
        body:  const Column(
          children: [
            Text("this is payload"),
            Text('payload'),
          ],
        ));
  }
}
