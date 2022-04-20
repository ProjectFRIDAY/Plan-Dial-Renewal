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
      home: BottomNavigation(),
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
            return const PageSegmentedControl();
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
    return const CupertinoPageScaffold(
      child: SafeArea(
        child: Text("안녕하십니까"),
      ),
    );
  }
}
