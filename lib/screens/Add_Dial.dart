import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'select_page.dart';

bool isFinish = false;

// Add Dial Page
class AddDialPage extends StatelessWidget {
  const AddDialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Plan Dial',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        border: Border(),
        backgroundColor: CupertinoColors.white,
      ),
      child: Column(children: const [
        AddDialTop(),
        AddDialName(),
        AddDialDay(),
        AddDialTime(),
        Spacer(),
        AddButton(),
        SizedBox(
          height: 80,
        )
      ]),
    );
  }
}

// Add Dial Page 상단부분
class AddDialTop extends StatelessWidget {
  const AddDialTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(child: Container(), flex: 1),
            const Flexible(
                child: Text("일정추가",
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

String tempDialName = '';

class AddDialName extends StatefulWidget {
  const AddDialName({Key? key}) : super(key: key);

  @override
  State<AddDialName> createState() => _AddDialNameState();
}

class _AddDialNameState extends State<AddDialName> {
  final dialNameController = TextEditingController();
  @override
  void dispose() {
    dialNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              autocorrect: false,
              controller: dialNameController,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1.5, color: CupertinoColors.black)),
              placeholder: "Ex) 독서하기",
              placeholderStyle: TextStyle(color: CupertinoColors.inactiveGray),
              padding: EdgeInsets.all(10),
              style: TextStyle(fontSize: 16),
              onChanged: (text) {
                tempDialName = text;
              },
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Text('를',
              style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}

class AddDialDay extends StatefulWidget {
  const AddDialDay({Key? key}) : super(key: key);

  @override
  State<AddDialDay> createState() => _AddDialDayState();
}

class _AddDialDayState extends State<AddDialDay> {
  List<String> showDay = ['월', '화', '수', '목', '금', '토', '일'];

  String dayNames() {
    String result = '';
    for (var i = 0; i <= 6; i++) {
      if (selectDayNumber[i] == 1) {
        result += showDay[i];
        result += ' / ';
      }
    }
    return result.substring(0, result.length - 3);
  }

  bool isSelectDay() {
    setState(() {});
    if (selectDayNumber.contains(1))
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              enabled: false,
              decoration: BoxDecoration(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1.5, color: CupertinoColors.black)),
              placeholder: isSelectDay() ? dayNames() : "Ex) 월 / 화 / 수",
              placeholderStyle: isSelectDay()
                  ? TextStyle(color: CupertinoColors.systemRed)
                  : TextStyle(color: CupertinoColors.inactiveGray),
              padding: EdgeInsets.all(10),
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Text('에',
              style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight: FontWeight.w600))
        ],
      ),
      onPressed: () {
        Navigator.of(context)
            .push(CupertinoPageRoute<void>(
                builder: (BuildContext context) => const SelectDayPage()))
            .then((value) {
          setState(() {});
        });
      },
    );
  }
}

class AddDialTime extends StatefulWidget {
  const AddDialTime({Key? key}) : super(key: key);

  @override
  State<AddDialTime> createState() => _AddDialTimeState();
}

class _AddDialTimeState extends State<AddDialTime> {
  String makeTime() {
    String result = '';
    for (var i = 0; i < 2; i++) {
      result += selectDateTime[i].hour.toString() +
          ':' +
          selectDateTime[i].minute.toString() +
          ' ~ ';
    }
    return result.substring(0, result.length - 3);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Row(
          children: [
            Expanded(
              child: CupertinoTextField(
                enabled: false,
                decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(width: 1.5, color: CupertinoColors.black)),
                placeholder: selectDateTime[0].hour != selectDateTime[1].hour ||
                        selectDateTime[0].minute != selectDateTime[1].minute
                    ? makeTime()
                    : "Ex) 6:00 AM ~ 8:30 PM",
                placeholderStyle:
                    selectDateTime[0].hour != selectDateTime[1].hour ||
                            selectDateTime[0].minute != selectDateTime[1].minute
                        ? TextStyle(color: CupertinoColors.systemPink)
                        : TextStyle(color: CupertinoColors.inactiveGray),
                padding: EdgeInsets.all(10),
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Text('동안 할게요',
                style: TextStyle(
                    fontSize: 17,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w600))
          ],
        ),
        onPressed: () {
          Navigator.of(context)
              .push(CupertinoPageRoute<void>(
                  builder: (BuildContext context) => const SelectTimePage()))
              .then((value) {
            setState(() {});
          });
        });
  }
}

// 확인버튼
class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: const Text(
          '확인',
          style: TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        color: CupertinoColors.activeBlue,
        onPressed: () {
          if (isFinish) {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('주의'),
                    content: const Text('모든 정보를 입력해 주세요.'),
                    actions: [
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          child: const Text("확인"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  );
                });
          } else {
            print(selectDayNumber);
            print(tempDialName);
            print(selectDateTime);
          }
        });
  }
}
