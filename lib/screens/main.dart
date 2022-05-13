import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
import 'package:plan_dial_renewal/screens/time_table.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/noti_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotiManager();
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
          icon: Icon(CupertinoIcons.clock), label: 'Dial'),
      const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.table), label: 'Table'),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: items, height: 55),
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
                CupertinoIcons.circle_fill,
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

class Item {
  const Item(
    this.index,
    this.title,
    this.subtitle,
    this.color,
  );

  final int index;
  final String title;
  final String subtitle;
  final Color color;
}

class ListViewWidget extends StatefulWidget {
  late final Icon icon;

  bool isdisable = false;

  ListViewWidget(Color color, {Key? key}) : super(key: key) {
    icon = Icon(
      CupertinoIcons.circle_fill,
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
      children: [
        Material(
          child: Slidable(
            // Specify a key if the Slidable is dismissible.
            key: ValueKey(0),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                widget.isdisable
                    ? const SlidableAction(
                        onPressed: null,
                        foregroundColor: Colors.white,
                        backgroundColor: CupertinoColors.inactiveGray,
                        icon: Icons.play_disabled,
                        label: 'Disable',
                      )
                    : const SlidableAction(
                        onPressed: null,
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 49, 149, 255),
                        icon: Icons.play_arrow,
                        label: 'Able',
                      ),
                const SlidableAction(
                  onPressed: null,
                  backgroundColor: CupertinoColors.systemRed,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: const ListTile(
                tileColor: CupertinoColors.white,
                leading: Icon(CupertinoIcons.calendar_circle_fill,
                    color: CupertinoColors.activeBlue, size: 40),
                title: Text('토요일까지 마감이다!!!',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('• 남는 시간'),
                trailing: Icon(CupertinoIcons.right_chevron)),
          ),
        ),
      ],
    );

    // ListView(
    //   children: List.generate(dials.length, (i) {
    //     return dials[i].toListTile(widget.icon);
    //   }),
    // );
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
