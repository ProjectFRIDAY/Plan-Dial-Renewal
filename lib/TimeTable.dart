import 'package:flutter/material.dart';

void main() {
  runApp(const TimeTable());
}

class TimeTable extends StatelessWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('star'),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ],
      )),
    );
  }
}
