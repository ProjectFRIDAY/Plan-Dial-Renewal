import 'package:flutter/cupertino.dart';

class CheckList extends StatefulWidget {
  const CheckList({Key? key}) : super(key: key);

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: const [CheckBox(), CheckBox(), CheckBox(), CheckBox()],
    );
  }
}

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
        pressedOpacity: 1,
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
