import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import '../service.dart';
//import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class ScreenTime extends StatefulWidget {
  const ScreenTime({super.key});

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}

class _ScreenTimeState extends State<ScreenTime> {
  Service service = Service();
  List<UsageInfo> usageStats = [];
  int carbon = 0;

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

      var queryUsageCarbon = await service.queryUsageCarbon(startDate, endDate);
      var queryUsageStats = queryUsageCarbon?.item1;
      var queryCarbon = queryUsageCarbon?.item2;

      setState(() {
        usageStats = queryUsageStats!;
        carbon = queryCarbon!;
      });

    } catch (err) {
      print(err);
    }
  }

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
                  title: Text(usageStats[index].packageName!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "First time stamp: ${DateTime
                              .fromMillisecondsSinceEpoch(
                              int.parse(usageStats[index].firstTimeStamp!))
                              .toIso8601String()}"),
                      Text(
                          "Last time stamp: ${DateTime
                              .fromMillisecondsSinceEpoch(
                              int.parse(usageStats[index].lastTimeStamp!))
                              .toIso8601String()}"),
                      Text(
                          "Last time used: ${DateTime
                              .fromMillisecondsSinceEpoch(
                              int.parse(usageStats[index].lastTimeUsed!))
                              .toIso8601String()}"),
                      Text(
                          "Total time used: ${(int.parse(usageStats[index].totalTimeInForeground!) / 1000 / 60).round()}"),
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
}
