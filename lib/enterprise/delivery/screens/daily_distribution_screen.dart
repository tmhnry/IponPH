import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/approved_daily_distribution.dart';
import '../widgets/pending_daily_distribution.dart';
import '../../../layout/names.dart';

class DailyDistributionScreen extends StatefulWidget {
  const DailyDistributionScreen(
    this.search,
  );

  final String search;

  @override
  _DailyDistributionScreenState createState() =>
      _DailyDistributionScreenState();
}

class _DailyDistributionScreenState extends State<DailyDistributionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  @override
  void initState() {
    controller = TabController(
      initialIndex: 1,
      length: DailyDistributionScreenTabs.tabNames.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(DailyDistributionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    // AppDatabase.instance.close();
    super.dispose();
  }

  void rebuild() => setState(() => null);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildMessage(context),
            buildTabBar(),
            tabs.elementAt(controller.index),
          ],
        ),
      );

  List<Widget> get tabs => [
        ApprovedDailyDistribution(
          widget.search,
        ),
        PendingDailyDistribution(
          widget.search,
        ),
      ];

//  memory leak notification
  Widget buildTabBar() => TabBar(
        controller: controller,
        isScrollable: true,
        tabs: buildTabs(),
        onTap: (_) => rebuild(),
      );

  Widget buildTab(String tabName) => Tab(
        child: Text(
          tabName,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      );

  List<Widget> buildTabs() => DailyDistributionScreenTabs.tabNames
      .map(
        (String tabName) => buildTab(tabName),
      )
      .toList();

  Widget buildMessage(BuildContext context) => Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: 10,
          left: 15,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 5,
                right: 5,
                left: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                border: BorderDirectional(
                  start: BorderSide(
                    width: 5,
                  ),
                ),
              ),
              child: Text(
                'Deliveries Today',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 20,
              ),
              child: Text(
                '$dateToday',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      );

  String get dateToday => DateFormat.yMMMMEEEEd().format(DateTime.now());
  // Widget buildSwitch() => Container(
  //       margin: EdgeInsets.only(left: 50, top: 15, bottom: 15),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 height: 10,
  //                 child: Switch(
  //                   value: true,
  //                   onChanged: (bool value) {},
  //                   activeColor: Colors.white,
  //                   activeTrackColor: Colors.orange,
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(left: 35),
  //                 child: Text(
  //                   'Approved Products',
  //                   style: TextStyle(
  //                     color: Colors.orange,
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 15,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
}
