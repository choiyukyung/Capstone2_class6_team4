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
  /*
      var reponse = await service.postUsageStats
        (
          widget.id,
          startDate,
          endDate
        );

 */
      var reponse = await service.queryUsageStats
        (
          startDate,
          endDate
      );
      if (reponse.isEmpty) print("Wrong input");

      setState(() {
        usageStats = reponse;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: initUsage,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(usageStats[index]['packageName']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Query time stamp: ${
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(usageStats[index]['nowTimeStamp']),
                            //isUtc:true
                          ).toIso8601String()}"),
                  Text(
                      "Last time used: ${
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(usageStats[index]['lastTimeUsed']),
                            //isUtc:true
                          ).toIso8601String()}"),
                  Text(
                      "Total time used: ${usageStats[index]['totalTimeInForeground']}"),
                ]
              ),
            );
          },
          //separatorBuilder: (context, index) => const Divider(),
          itemCount: usageStats.length,
        ),
      ),
    );
  }
}