import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_dial_renewal/screens/time_table.dart';

// 다이얼 생성 페이지
class AddDialPage extends StatelessWidget {
  const AddDialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        home: CupertinoPageScaffold(
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
        Text(
          '다이얼 추가 페이지 입니다.',
          style: TextStyle(fontSize: 20),
        )
      ]),
    ));
  }
}

// 다이얼 생성페이지의 상단 부분
class AddDialTop extends StatelessWidget {
  const AddDialTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(child: Container(), flex: 1),
            Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("일정추가",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        minSize: 0,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text(
                          '취소',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
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
