import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_dial.dart';
import 'calendar.dart';
import 'check_list.dart';

// TimeTable slid sement control (하단에 Week & Today 버튼)
class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Week'),
    1: Text('            Today            '),
  };

  int? currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        // Week Page & Today Page 구분
        if (currentValue == 0)
          Column(
            children: const [
              WeekTop(),
              // Week Page == Calendar
              SizedBox(height: 500, child: Calendar())
            ],
          )
        else
          Column(
            children: const [TodayTop(), TodayPage()],
          ),
        const Spacer(),
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
          height: 25,
        )
      ],
    ));
  }
}

// Week Page 상단 부분
class WeekTop extends StatelessWidget {
  const WeekTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Flexible(child: Container(), flex: 1),
          Flexible(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Text("TimeTable",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 7, 0)),
                      CupertinoButton(
                          padding: const EdgeInsets.all(0.0),
                          minSize: 0,
                          onPressed: () {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('전체 일정 삭제'),
                                    content: const Text(
                                        '\'확인\'을 누르시면 모든 일정이 삭제됩니다.'),
                                    actions: [
                                      CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: const Text("확인"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: const Text("취소"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  );
                                });
                          },
                          child: const Icon(CupertinoIcons.trash,
                              color: CupertinoColors.destructiveRed, size: 20)),
                    ]),
                    CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        minSize: 0,
                        onPressed: () => Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const AddDialPage())),
                        child: const Icon(CupertinoIcons.add, size: 25)),
                  ]),
              flex: 30),
          Flexible(child: Container(), flex: 2),
        ]),
        const Divider(
          color: CupertinoColors.black,
          height: 20,
        ),
      ],
    );
  }
}

// Today Page 상단부분
class TodayTop extends StatelessWidget {
  const TodayTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(child: Container(), flex: 1),
            const Flexible(
                child: Text("To Do List",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                flex: 30),
            Flexible(child: Container(), flex: 2),
          ],
        ),
        const Divider(
          color: CupertinoColors.black,
          height: 20,
        ),
      ],
    );
  }
}

// Today Page
class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: const [
          Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
          Text('오늘 실천 완료한 계획을 눌러 체크하세요!',
              style: TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 10),
        const CheckList()
      ],
    );
  }
}
