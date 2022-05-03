import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements Observer {
  _MyHomePageState() {
    DialManager().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var urgentDial = DialManager().getUrgentDial();

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            const ListIndexWidget("Next"),
            MainTile(
              title: urgentDial != null ? urgentDial.name : "다이얼이 없음",
              subtitle: urgentDial != null
                  ? Dial.secondsToString(urgentDial.getLeftTimeInSeconds())
                  : "다이얼이 없음",
              icon: const Icon(
                CupertinoIcons.alarm_fill,
                color: CupertinoColors.systemRed,
                size: 50,
              ),
            ),
            const ListIndexWidget("Dial"),
            Expanded(child: ListViewWidget(CupertinoColors.systemBlue))
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  @override
  void onChanged() {
    setState(() {});
  }
}

class ListViewWidget extends StatefulWidget {
  late final Icon icon;

  ListViewWidget(Color color, {Key? key}) : super(key: key) {
    icon = Icon(
      CupertinoIcons.alarm_fill,
      color: color,
      size: 35,
    );
  }

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<ListViewWidget> implements Observer {
  @override
  Widget build(BuildContext context) {
    var dials = DialManager().getAllDials();
    dials.sort(
        (a, b) => a.getLeftTimeInSeconds().compareTo(b.getLeftTimeInSeconds()));
    if (dials.isNotEmpty) dials.removeAt(0);

    return ListView(
      children: List.generate(dials.length, (i) {
        return dials[i].toListTile(widget.icon);
      }),
    );
  }

  @override
  void onChanged() {
    setState(() {});
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
