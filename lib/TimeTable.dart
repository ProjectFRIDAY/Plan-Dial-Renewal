import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TimeTable());
}

int _sliding = 0;

class TimeTable extends StatelessWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Plan Dial',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Container(
              child: Column(
                children: [
                  // page 이름과 전체 삭제, 플러스 아이콘, divier line
                  Column(
                    children: [
                      Row(
                        children: const [
                          Text("TimeTable",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25)),
                          Icon(
                            CupertinoIcons.trash,
                            color: Colors.red,
                          ),
                          Icon(
                            CupertinoIcons.add,
                            color: CupertinoColors.activeBlue,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black54,
                        height: 20,
                      )
                    ],
                  ),
                  // calendar
                  Container(
                    child: const Text(
                      'calendar',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  // TimeTable 안의 Week and Today page
                  SegmentedControl()
                ],
              ),
            )
            //bottomNavigationBar: 이부분은 민규님께서 개발함.,
            ));
  }
}

// TimeTable 안의 Week and Today page
class SegmentedControl extends StatefulWidget {
  const SegmentedControl({Key? key}) : super(key: key);

  @override
  State createState() => SegmentedControlState();
}

class SegmentedControlState extends State<SegmentedControl> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Week'),
    //사이즈 맞추는 용도로 띄어쓰기를 함.
    1: Text('            Today            '),
  };

  int? currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      children: children,
      onValueChanged: (int? newValue) {
        setState(() {
          currentValue = newValue;
        });
      },
      groupValue: currentValue,
    );
  }
}
