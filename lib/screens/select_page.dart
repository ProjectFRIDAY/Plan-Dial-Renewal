import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// SelectDayPage
class SelectDayPage extends StatelessWidget {
  const SelectDayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Plan Dial',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        border: Border(),
        backgroundColor: CupertinoColors.white,
      ),
      child: SelectDayList(),
    );
  }
}

// Day select ListView
class SelectDayList extends StatefulWidget {
  const SelectDayList({Key? key}) : super(key: key);

  @override
  State<SelectDayList> createState() => _SelectDayListState();
}

class _SelectDayListState extends State<SelectDayList> {
  List<String> dayNameList = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: [
            for (var i = 0; i < 7; i++) SelectDayButton(dayNameList[i])
          ],
        ),
      ],
    );
  }
}

// Day select Button
class SelectDayButton extends StatefulWidget {
  final String dayName;
  const SelectDayButton(this.dayName) : super();

  @override
  State<SelectDayButton> createState() => _SelectDayButtonState();
}

class _SelectDayButtonState extends State<SelectDayButton> {
  bool ischecked = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.all(0),
        pressedOpacity: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.dayName,
                    style:
                        TextStyle(color: CupertinoColors.black, fontSize: 18)),
                const Spacer(),
                Icon(
                  CupertinoIcons.check_mark,
                  color: ischecked
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.white,
                )
              ],
            ),
            const Divider(
              thickness: 1,
              color: CupertinoColors.inactiveGray,
            )
          ],
        ),
        onPressed: () {
          setState(() {
            if (ischecked) {
              ischecked = false;
            } else {
              ischecked = true;
            }
          });
        });
  }
}

// SelectTimePage
class SelectTimePage extends StatelessWidget {
  const SelectTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        CupertinoButton(
            child: const Text(
              '확인',
              style: TextStyle(
                  color: CupertinoColors.white, fontWeight: FontWeight.bold),
            ),
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}

// SelectTimePage Route
Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SelectTimePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
