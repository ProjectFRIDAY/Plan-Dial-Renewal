import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';

/// CheckButton을 리스트 뷰로 보여주는 class
class CheckList extends StatefulWidget {
  const CheckList({Key? key}) : super(key: key);

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> implements Observer {
  _CheckListState() {
    DialManager().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final todayDials = DialManager().getTodayDials();

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: List.generate(
        todayDials.length,
        (i) {
          return Container(
            child: CheckBox(todayDials[i].name),
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          );
        },
      ),
    );
  }

  @override
  void onChanged() {
    if (mounted) setState(() {});
  }
}

// To Do List Check Box Class
class CheckBox extends StatefulWidget {
  final String title;

  const CheckBox(this.title, {Key? key}) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxTestState();
}

class _CheckBoxTestState extends State<CheckBox> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        pressedOpacity: 1,
        child: Text(
          widget.title,
          style: const TextStyle(
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
