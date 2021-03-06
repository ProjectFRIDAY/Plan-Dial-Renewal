import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
import 'package:plan_dial_renewal/screens/time_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../utils/noti_manager.dart';
import 'Add_Dial.dart';
import 'select_page.dart';

const int secondsPerWeek = Duration.secondsPerDay * 7;
GlobalKey initPlus = GlobalKey();
GlobalKey dialTab = GlobalKey();
GlobalKey tableTab = GlobalKey();
GlobalKey listTileDrag = GlobalKey();

bool isFirstUsing = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotiManager();
    return CupertinoApp(
      title: 'Plan Dial',
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: ShowCaseWidget(
        builder: Builder(
          builder: (context) => const CupertinoPageScaffold(
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
        ),
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();
    _showShowCaseWidget();
  }

  Future<void> _showShowCaseWidget() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    isFirstUsing = !sharedPreferences.containsKey("isFirstUsing");

    if (isFirstUsing) {
      WidgetsBinding.instance!.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)!
              .startShowCase([initPlus, dialTab, tableTab, listTileDrag]));
      sharedPreferences.setBool("isFirstUsing", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          icon: Showcase(
              key: dialTab,
              description: '???????????? ????????? ???????????????',
              shapeBorder: const CircleBorder(),
              overlayPadding: const EdgeInsets.fromLTRB(25, 6, 25, 20),
              showcaseBackgroundColor: CupertinoColors.systemPink,
              descTextStyle: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white),
              child: const Icon(CupertinoIcons.clock)),
          label: 'Dial'),
      BottomNavigationBarItem(
          icon: Showcase(
              key: tableTab,
              description: '??? ?????? ????????? ???????????????',
              shapeBorder: const CircleBorder(),
              overlayPadding: const EdgeInsets.fromLTRB(25, 6, 25, 20),
              showcaseBackgroundColor: CupertinoColors.systemPink,
              descTextStyle: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white),
              child: const Icon(CupertinoIcons.table)),
          label: 'Table'),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListIndexWidget("Next", false),
            MainTile(
              pressable: urgentDial == null,
              title: urgentDial != null ? urgentDial.name : "?????? ????????????",
              subtitle: urgentDial != null
                  ? Dial.secondsToString(urgentDial.getLeftTimeInSeconds())
                  : "????????? ?????? ????????? ???????????????.",
              icon: urgentDial != null
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: Transform(
                        transform: Matrix4.rotationY(3.14), // ?????? ??????
                        child: CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 234, 142, 134),
                          valueColor: const AlwaysStoppedAnimation(
                              Color.fromARGB(255, 234, 76, 62)),
                          strokeWidth: 36,
                          value: urgentDial.getLeftTimeInSeconds() /
                              secondsPerWeek,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Showcase(
                          key: initPlus,
                          description: '+ ????????? ?????? ????????? ????????? ??? ????????????',
                          shapeBorder: CircleBorder(),
                          overlayPadding: EdgeInsets.all(8),
                          showcaseBackgroundColor: CupertinoColors.systemPink,
                          descTextStyle: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                          child: Icon(CupertinoIcons.add, size: 40)),
                    ),
            ),
            ListIndexWidget("Dials", urgentDial != null),
            const Expanded(child: ListViewWidget())
          ],
        ),
      ),
    );
  }

  @override
  void onChanged() {
    if (mounted) setState(() {});
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
  const ListViewWidget({Key? key}) : super(key: key);

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<ListViewWidget> implements Observer {
  bool _loading = true;

  _ListViewState() {
    DialManager().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var dials = DialManager().getAllDials();
    dials.sort(
        (a, b) => a.getLeftTimeInSeconds().compareTo(b.getLeftTimeInSeconds()));

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dials.isEmpty) {
      return const Center(
        child: Text("????????? ????????????."),
      );
    }

    return ListView(
      children: List.generate(
        dials.length,
        (i) {
          return SlideIndexWidget(dials[i]);
        },
      ),
    );
  }

  @override
  void onChanged() {
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}

class SlideIndexWidget extends StatefulWidget {
  final Dial dial;

  const SlideIndexWidget(this.dial, {Key? key}) : super(key: key);

  @override
  State<SlideIndexWidget> createState() => _SlideIndexWidgetState();
}

class _SlideIndexWidgetState extends State<SlideIndexWidget> {
  @override
  Widget build(BuildContext context) {
    Widget arrow;

    if (isFirstUsing) {
      arrow = Showcase(
          key: listTileDrag,
          description: '???????????? ????????? ????????????',
          shapeBorder: const CircleBorder(),
          overlayPadding: const EdgeInsets.all(8),
          showcaseBackgroundColor: CupertinoColors.systemPink,
          descTextStyle:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          child: const Icon(CupertinoIcons.right_chevron));
      isFirstUsing = false;
    } else {
      arrow = const Icon(CupertinoIcons.right_chevron);
    }

    return Material(
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: ValueKey(0),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            !widget.dial.disabled
                ? SlidableAction(
              onPressed: (context) {
                widget.dial.disabled = true;
                DialManager().updateDial(widget.dial);
              },
              foregroundColor: Colors.white,
              backgroundColor: CupertinoColors.inactiveGray,
              icon: Icons.alarm_off,
              label: 'Alarm',
            )
                : SlidableAction(
              onPressed: (context) {
                widget.dial.disabled = false;
                DialManager().updateDial(widget.dial);
              },
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 49, 149, 255),
              icon: Icons.alarm_on,
              label: 'Alarm',
            ),
            SlidableAction(
              onPressed: (context) {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('\"' + widget.dial.name + '\" ?????? ??????'),
                        content: Text('\'??????\'??? ???????????? ????????? ???????????????.'),
                        actions: [
                          CupertinoDialogAction(
                              isDefaultAction: true,
                              child: const Text("??????"),
                              onPressed: () {
                                DialManager().removeDialById(widget.dial.id);
                                Navigator.pop(context);
                              }),
                          CupertinoDialogAction(
                              isDefaultAction: true,
                              child: const Text("??????"),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    });
              },
              backgroundColor: CupertinoColors.systemRed,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          tileColor: CupertinoColors.white,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(24.5, 15, 10, 8),
            child: SizedBox(
              height: 10,
              width: 10,
              child: Transform(
                transform: Matrix4.rotationY(3.14), // ?????? ??????
                child: CircularProgressIndicator(
                  backgroundColor: widget.dial.disabled
                      ? Color.fromARGB(255, 220, 220, 220)
                      : Color.fromARGB(255, 215, 209, 250),
                  valueColor: AlwaysStoppedAnimation(widget.dial.disabled
                      ? Color.fromARGB(255, 180, 180, 180)
                      : Color.fromARGB(255, 85, 104, 206)),
                  strokeWidth: 36,
                  value: widget.dial.getLeftTimeInSeconds() / secondsPerWeek,
                ),
              ),
            ),
          ),
          title: Text(widget.dial.name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: widget.dial.disabled
                      ? CupertinoColors.inactiveGray
                      : CupertinoColors.black)),
          subtitle:
              Text(Dial.secondsToString(widget.dial.getLeftTimeInSeconds())),
          trailing: arrow,
        ),
      ),
    );
  }
}

class ListIndexWidget extends StatelessWidget {
  final String title;
  final bool hasAddIcon;

  const ListIndexWidget(this.title, this.hasAddIcon, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ];

    if (hasAddIcon) {
      children.add(Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: CupertinoButton(
              padding: const EdgeInsets.all(0.0),
              minSize: 0,
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (BuildContext context) => AddDialPage()));
                selectDayNumber = [0, 0, 0, 0, 0, 0, 0];
                selectDateTime = [
                  getFiveTimesTime(DateTime.now()),
                  getFiveTimesTime(DateTime.now())
                ];
                select = false;
              },
              child: const Icon(CupertinoIcons.add, size: 25))));
    }

    return Container(
      child: Row(
        children: children,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      decoration: const BoxDecoration(
        color: CupertinoColors.extraLightBackgroundGray,
      ),
      height: 40,
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
    );
  }
}

class MainTile extends StatelessWidget {
  final bool pressable;

  final String title;
  final String subtitle;
  final Widget? icon;

  const MainTile(
      {Key? key,
      required this.pressable,
      required this.title,
      required this.subtitle,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          splashFactory:
              pressable ? InkRipple.splashFactory : NoSplash.splashFactory,
        ),
        child: Padding(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 22.5),
              icon!,
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Padding(
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 5.0),
                  ),
                ],
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () {
          if (pressable) {
            Navigator.of(context).push(CupertinoPageRoute<void>(
                builder: (BuildContext context) => AddDialPage()));
            selectDayNumber = [0, 0, 0, 0, 0, 0, 0];
            selectDateTime = [
              getFiveTimesTime(DateTime.now()),
              getFiveTimesTime(DateTime.now())
            ];
            select = false;
          }
        });
  }
}
