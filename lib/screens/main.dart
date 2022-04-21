import 'dart:ui';

import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/screens/time_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Plan Dial',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Plan Dial',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          border: Border(),
          backgroundColor: CupertinoColors.white,
        ),
        child: BottomNavigation(),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.star_fill), label: 'List'),
      const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.star_fill), label: 'Time Table'),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: items),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const MyHomePage();
          case 1:
            return const TimeTablePage();
          default:
            return const MyHomePage();
        }
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            const ListIndexWidget("Next"),
            const MainTile(
              title: '재활용 쓰레기 버리기',
              subtitle: '10분 전',
              icon: Icon(
                CupertinoIcons.alarm_fill,
                color: CupertinoColors.systemRed,
                size: 50,
              ),
            ),
            const ListIndexWidget("Dial"),
            Expanded(child: ListViewWidget(CupertinoColors.systemBlue)),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }
}

// 추후 동적 생성으로 변경 필요
class ListViewWidget extends StatelessWidget {
  late final Icon icon;

  ListViewWidget(Color color, {Key? key}) : super(key: key) {
    icon = Icon(
      CupertinoIcons.alarm_fill,
      color: color,
      size: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CupertinoListTile(
          //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
          leading: icon,
          title: const Text('빨래하기'),
          subtitle: const Text('30분 전'),
          border: const Border(),
        ),
        CupertinoListTile(
          //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
          leading: icon,
          title: const Text('세탁하기'),
          subtitle: const Text('50분 전'),
          border: const Border(),
        ),
      ],
    );
  }
}

class ListIndexWidget extends StatelessWidget {
  final String title;

  const ListIndexWidget(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      decoration: const BoxDecoration(
        color: CupertinoColors.extraLightBackgroundGray,
      ),
      height: 40,
      padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
    );
  }
}

class MainTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;

  const MainTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 5.0),
                ),
              ],
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
    );
  }
}
