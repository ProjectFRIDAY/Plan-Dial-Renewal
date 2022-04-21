import 'package:flutter/cupertino.dart';

// To Do List Check Box
class CheckBox extends StatefulWidget {
  const CheckBox({Key? key}) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxTestState();
}

class _CheckBoxTestState extends State<CheckBox> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: const Text(
          '빨래하기',
          style: TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        color: state ? CupertinoColors.activeBlue : CupertinoColors.systemGrey4,
        onPressed: () {
          if (state) {
            setState(() {
              state = false;
            });
          } else {
            setState(() {
              state = true;
            });
          }
        });
  }
}
