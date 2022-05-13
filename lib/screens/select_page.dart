import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// SelectDayPage
class SelectDayPage extends StatelessWidget {
  const SelectDayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Plan Dial',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        border: Border(),
        backgroundColor: CupertinoColors.white,
      ),
      child: SelectDayList(),
    );
  }
}

// Day select ListView
class SelectDayList extends StatefulWidget {
  const SelectDayList({Key? key}) : super(key: key);

  @override
  State<SelectDayList> createState() => _SelectDayListState();
}

class _SelectDayListState extends State<SelectDayList> {
  List<String> dayNameList = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: [
            for (var i = 0; i < 7; i++) SelectDayButton(dayNameList[i], i)
          ],
        ),
      ],
    );
  }
}

List<int> selectDayNumber = [0, 0, 0, 0, 0, 0, 0];

// Day select Button
class SelectDayButton extends StatefulWidget {
  final String dayName;
  final int dayCount;
  SelectDayButton(this.dayName, this.dayCount) : super();

  @override
  State<SelectDayButton> createState() => _SelectDayButtonState();
}

class _SelectDayButtonState extends State<SelectDayButton> {
  bool isChecked() {
    if (1 == selectDayNumber[widget.dayCount]) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.all(0),
        pressedOpacity: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.dayName,
                    style:
                        TextStyle(color: CupertinoColors.black, fontSize: 18)),
                const Spacer(),
                Icon(
                  CupertinoIcons.check_mark,
                  color: isChecked()
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.white,
                )
              ],
            ),
            const Divider(
              thickness: 1,
              color: CupertinoColors.inactiveGray,
            )
          ],
        ),
        onPressed: () {
          setState(() {
            if (isChecked()) {
              selectDayNumber[widget.dayCount] = 0;
            } else {
              selectDayNumber[widget.dayCount] = 1;
            }
          });
        });
  }
}

// SelectTimePage
class SelectTimePage extends StatelessWidget {
  const SelectTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Plan Dial',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        border: Border(),
        backgroundColor: CupertinoColors.white,
      ),
      child: SelectTimePicker(),
    );
  }
}

// SelectTimePicker
class SelectTimePicker extends StatefulWidget {
  const SelectTimePicker({Key? key}) : super(key: key);

  @override
  State<SelectTimePicker> createState() => _SelectTimePickerState();
}

List<DateTime> selectDateTime = [DateTime.now(), DateTime.now()];

class _SelectTimePickerState extends State<SelectTimePicker> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('시작시간'),
    1: Text('          마감시간          '),
  };

  int? currentValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: Column(
        children: [
          if (currentValue == 0)
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (value) {
                  selectDateTime[0] = value;
                },
                initialDateTime: DateTime.now(),
              ),
            )
          else
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (value) {
                  selectDateTime[1] = value;
                },
                initialDateTime: DateTime.now(),
              ),
            ),
          CupertinoSlidingSegmentedControl<int>(
            padding: EdgeInsets.all(4),
            children: children,
            onValueChanged: (int? newValue) {
              setState(() {
                currentValue = newValue;
              });
            },
            groupValue: currentValue,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
