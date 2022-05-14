import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
import 'package:plan_dial_renewal/utils/db_manager.dart';

import '../models/dial.dart';

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
            child: CheckBox(todayDials[i]),
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
  final Dial dial;

  const CheckBox(this.dial, {Key? key}) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxTestState();
}

class _CheckBoxTestState extends State<CheckBox> {
  bool _ready = false;
  int _checkId = -1;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    if (now.hour < DialManager.dayChangeHour) {
      now.subtract(const Duration(days: 1));
    }

    if (!_ready) {
      DbManager()
          .getCheckListId(widget.dial.id, now.year, now.month, now.day)
          .then((id) {
        _checkId = id;
        setState(() {
          _ready = true;
        });
      });

      return _DefaultCheckBox(widget.dial.name);
    }

    return CupertinoButton(
        pressedOpacity: 1,
        child: Text(
          widget.dial.name,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        color: (_checkId >= 0)
            ? CupertinoColors.activeBlue
            : CupertinoColors.systemGrey4,
        onPressed: () {
          if (_checkId >= 0) {
            DbManager()
                .uncheck(widget.dial, now.year, now.month, now.day)
                .then((d) {
              setState(() {
                _ready = false;
              });
            });
          } else {
            DbManager()
                .check(widget.dial, now.year, now.month, now.day)
                .then((d) {
              setState(() {
                _ready = false;
              });
            });
          }
        });
  }
}

class _DefaultCheckBox extends StatelessWidget {
  final String title;

  const _DefaultCheckBox(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: null,
      child: Text(
        title,
        style: const TextStyle(
            color: CupertinoColors.white, fontWeight: FontWeight.bold),
      ),
      color: CupertinoColors.systemGrey4,
      onPressed: null,
    );
  }
}
