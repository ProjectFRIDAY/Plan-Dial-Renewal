/*
할일!
1. UI적인 부분을 절대적인 값 말고 상대적인 값으로 변경해서 display 비율에 따라 자동 조정 기능 고려하기
2. 46line : 사이즈 맞추는 용도로 띄어쓰기를 함. ,UI 불안정할 시 수정
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TimeTable());
}

class TimeTable extends StatelessWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            //앱 상단 : 서비스 명
            appBar: AppBar(
              title: const Text('Plan Dial',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: PageSegmentedControl()
            //bottomNavigationBar: 이부분은 민규님께서 개발함.
            ));
  }
}

// Page 정보 & TimeTable 안의 Week and Today page
class PageSegmentedControl extends StatefulWidget {
  const PageSegmentedControl({Key? key}) : super(key: key);

  @override
  State createState() => SegmentedControlState();
}

class SegmentedControlState extends State<PageSegmentedControl> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Week'),
    1: Text('            Today            '),
  };

  int? currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Week Page & Today Page 구분
        if (currentValue == 0)
          Column(
            children: [WeekTop(), WeekPage()],
          )
        else
          Column(
            children: [TodayTop(), TodayPage()],
          ),
        CupertinoSlidingSegmentedControl<int>(
          children: children,
          onValueChanged: (int? newValue) {
            setState(() {
              currentValue = newValue;
            });
          },
          groupValue: currentValue,
        ),
      ],
    );
  }
}

// Week Page의 이름과 전체 삭제, 플러스 아이콘 & divider line
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
                    Row(children: const [
                      Text("TimeTable",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      Padding(padding: EdgeInsets.fromLTRB(0, 0, 7, 0)),
                      Icon(CupertinoIcons.trash, color: Colors.red, size: 20),
                    ]),
                    const Icon(CupertinoIcons.add,
                        color: CupertinoColors.activeBlue, size: 25),
                  ]),
              flex: 30),
          Flexible(child: Container(), flex: 2),
        ]),
        const Divider(
          color: Colors.black54,
          height: 20,
        ),
      ],
    );
  }
}

// Today Page의 이름 & divider line
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
                child: Text("To Do",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                flex: 30),
            Flexible(child: Container(), flex: 2),
          ],
        ),
        const Divider(
          color: Colors.black54,
          height: 20,
        ),
      ],
    );
  }
}

// Week Page
class WeekPage extends StatelessWidget {
  const WeekPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Week',
          style: TextStyle(fontSize: 25),
        ),
        Text('currentValue가 0입니다.'),
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
        Row(
          children: const [
            Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
            Text(
              '오늘 실천 완료한 계획을 눌러 체크하세요!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Text(
          'Today',
          style: TextStyle(fontSize: 25),
        ),
        const Text('currentValue가 1입니다.'),
      ],
    );
  }
}
