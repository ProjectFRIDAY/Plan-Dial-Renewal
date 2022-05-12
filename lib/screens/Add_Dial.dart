import 'dart:ffi';

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

class AddDialName extends StatefulWidget {
  const AddDialName({Key? key}) : super(key: key);

  @override
  State<AddDialName> createState() => _AddDialNameState();
}

final dialNameController = TextEditingController();

class _AddDialNameState extends State<AddDialName> {
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
              controller: dialNameController,
              decoration: BoxDecoration(
                  color: CupertinoColors.extraLightBackgroundGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1.5, color: CupertinoColors.black)),
              placeholder: "Ex) 독서하기",
              placeholderStyle: TextStyle(color: CupertinoColors.inactiveGray),
              padding: EdgeInsets.all(10),
              style: TextStyle(fontSize: 16),
              onChanged: (text) {
                print(text);
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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: CupertinoButton(
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              enabled: false,
              decoration: BoxDecoration(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1.5, color: CupertinoColors.black)),
              placeholder: "Ex) 월 / 화 / 수",
              placeholderStyle: TextStyle(color: CupertinoColors.inactiveGray),
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
        Navigator.of(context).push(CupertinoPageRoute<void>(
            builder: (BuildContext context) => const SelectDayPage()));
      },
    ));
  }
}

class AddDialTime extends StatefulWidget {
  const AddDialTime({Key? key}) : super(key: key);

  @override
  State<AddDialTime> createState() => _AddDialTimeState();
}

class _AddDialTimeState extends State<AddDialTime> {
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
                placeholder: "Ex) 6:00 AM ~ 8:30 PM",
                placeholderStyle:
                    TextStyle(color: CupertinoColors.inactiveGray),
                padding: EdgeInsets.all(10),
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Text('에 할게요',
                style: TextStyle(
                    fontSize: 17,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w600))
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute<void>(
              builder: (BuildContext context) => const SelectTimePage()));
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
            print(dialNameController.text);
            print(selectDayNumber);
          }
        });
  }
}
