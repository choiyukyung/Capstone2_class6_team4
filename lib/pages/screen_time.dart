import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:usage_stats/usage_stats.dart';

import '../services/myapi.dart';
import '../services/mychart.dart';
import '../services/mycolor.dart';
//import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class ScreenTime extends StatefulWidget {
  final String id;
  const ScreenTime(this.id, {super.key});

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}

class _ScreenTimeState extends State<ScreenTime> {
  Service service = Service();
  List<dynamic> usageStats = [];
  int pieTouchedIndex = 0;
  int barTouchedIndex = 0;
  double targetCarbon = 5.0;

  double barWidth = 20;
  double barShadowOpacity = 0.4;


  //for usage_stats
  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(
          endDate.year, endDate.month, endDate.day, 0, 0, 0);

      var queryUsageStats = await service.getUsageStats(
          startDate, endDate, widget.id);
      if (queryUsageStats == null) print("Wrong input");

      setState(() {
        usageStats = queryUsageStats;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          children: [
            Container(),
          ],
        ),
      ),
    );
  }
}
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Usage Stats"), actions: const [
          IconButton(
            onPressed: UsageStats.grantUsagePermission,
            icon: Icon(Icons.settings),
          )
        ]),
        body: Container(
          child: RefreshIndicator(
            onRefresh: initUsage,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(usageStats[index]['packageName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                          "Now time stamp: ${
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(usageStats[index]['nowTimeStamp']),
                                  //isUtc:true
                              ).toIso8601String()}"),
                      Text(
                          "Now time stamp: ${
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(usageStats[index]['lastTimeUsed']),
                                  //isUtc:true
                              ).toIso8601String()}"),
                          Text(
                          "Total time used: ${(
                              int.parse(usageStats[index]['totalTimeInForeground']) / 1000 / 60).round()
                          .toString()}"),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: usageStats.length,
            ),
          ),
        ),
      ),
    );
  }
*/