import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TodayList());
}

class TodayList extends StatelessWidget {
  const TodayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text('Hello, World!'),
      ),
    ));
  }
}
