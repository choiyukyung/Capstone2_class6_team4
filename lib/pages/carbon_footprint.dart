import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/user.dart';
import '../services/mychart.dart';
import '../services/mycolor.dart';
import '../services/myapi.dart';

class CarbonFootprint extends StatefulWidget {
  User? user;
  CarbonFootprint({required this.user, super.key});

  @override
  State<CarbonFootprint> createState() => _CarbonFootprintState();
}

class _CarbonFootprintState extends State<CarbonFootprint> {
  Service? service;
  var carbonYesterday = [];
  var carbonChange = [];
  var carbonDailyStats = [];
  var carbonWeeklyStats = [];
  var carbonBaseValue = 0.0;
  var carbonInObj = {};
  var walingRanking = [];

  int pieTouchedIndex = 0;
  int barTouchedIndex = 0;
  double targetCarbon = 5.0;

  double barWidth = 20;
  double barShadowOpacity = 0.4;

  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();

    service = Service(user: widget.user);
    initCarbonData();
  }

  Future<dynamic> initCarbonData() async {
    dynamic response = await service?.queryCarbonYesterday();
    if (response.isNotEmpty){
      carbonYesterday = response;
    }

    response = await service?.queryCarbonChange();
    if (response.isNotEmpty){
      carbonChange = response;
    }

    response = await service?.queryCarbonDailyStats();
    if (response.isNotEmpty){
      carbonDailyStats = response;
    }

    response = await service?.queryCarbonWeeklyStats();
    if (response.isNotEmpty){
      carbonWeeklyStats = response;
    }

    response = await service?.queryCarbonBaseValue();
    if (response!=0){
      carbonBaseValue = response;
    }

    response = await service?.queryCarbonInObj();
    if (response.isNotEmpty){
      carbonInObj = response;
    }

    response = await service?.getWalkingRanking();
    if (response.isNotEmpty){
      walingRanking = response;
    }
  }

  void cardClickEvent(BuildContext context, String nickName) {
    String content = nickName;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 개수
      child: Scaffold(
        backgroundColor: MyColors.deepGreenBlue,
        appBar: const TabBar(
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 15.0),
          unselectedLabelColor: MyColors.brightGreenBlue,
          tabs: [
            Tab(text: 'report',),
            Tab(text: 'ranking'),
          ],
        ),
        body: TabBarView(
          children: [
            //Tab1
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 1500,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey, width: 1.5,),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12.0,),
                        Row(
                          children: [
                            const Text(
                              "Daily report",
                              style: TextStyle(fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              "\ndate: ${DateFormat('MM.dd').format(
                                  yesterday)}\nreporter: SGreenTime",
                              style: const TextStyle(fontSize: 9.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50.0,),
                        const Text(
                          " ∎  The biggest cause of digital carbon",
                          style: TextStyle(fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 100,),
                        Center(
                          child: SizedBox(
                            width: 110, height: 110,
                            child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final shortestSide = constraints.biggest
                                      .shortestSide;
                                  return PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse.touchedSection ==
                                                    null) {
                                              pieTouchedIndex = -1;
                                              return;
                                            }
                                            pieTouchedIndex =
                                                pieTouchResponse.touchedSection!
                                                    .touchedSectionIndex;
                                          });
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 10,
                                      centerSpaceRadius: 35,
                                      sections: MyPieChart.showingSections(
                                          List.generate(4, (i) => double.parse(carbonYesterday?[i]["appCarbon"])),
                                          shortestSide,
                                          pieTouchedIndex
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                        const Spacer(),
                        //SizedBox(height: 80,),

                        const Text(
                          " ∎  Daily carbon amount changes",
                          style: TextStyle(fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 40,),
                        AspectRatio(
                          aspectRatio: 0.8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.center,
                                maxY: 5,
                                minY: -5,
                                groupsSpace: 12,
                                barTouchData: BarTouchData(
                                  handleBuiltInTouches: false,
                                  touchCallback: (FlTouchEvent event,
                                      barTouchResponse) {
                                    if (!event.isInterestedForInteractions ||
                                        barTouchResponse == null ||
                                        barTouchResponse.spot == null) {
                                      setState(() {
                                        barTouchedIndex = -1;
                                      });
                                      return;
                                    }
                                    final rodIndex = barTouchResponse.spot!
                                        .touchedRodDataIndex;
                                    if (MyBarChart.isShadowBar(rodIndex)) {
                                      setState(() {
                                        barTouchedIndex = -1;
                                      });
                                      return;
                                    }
                                    setState(() {
                                      barTouchedIndex =
                                          barTouchResponse.spot!.touchedBarGroupIndex;
                                    });
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 32,
                                      getTitlesWidget: (double, TitleMeta) {
                                        return BarBottomTitles(double, TitleMeta);
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (double, TitleMeta) {
                                        return BarLeftTitles(double, TitleMeta);
                                      },
                                      interval: 1,
                                      reservedSize: 42,
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  checkToShowHorizontalLine: (value) =>
                                  value % 5 == 0,
                                  getDrawingHorizontalLine: (value) {
                                    if (value == 0) {
                                      return FlLine(
                                        color: MyColors.brightGreenBlue.withOpacity(
                                            0.1),
                                        strokeWidth: 3,
                                      );
                                    }
                                    return FlLine(
                                      color: MyColors.brightGreenBlue.withOpacity(
                                          0.05),
                                      strokeWidth: 0.8,
                                    );
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: List.generate(carbonChange.length, (i) => {
                                  "key": carbonChange[i]["appEntry"],
                                  "value": double.parse(carbonChange[i]["appCarbon"]),
                                })
                                    .map(
                                      (e) =>
                                      MyBarChart.generateBarGroup(
                                        e["key"],
                                        e["value"],
                                        barTouchedIndex,
                                        barWidth,
                                        barShadowOpacity,
                                      ),
                                )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        //const SizedBox(height: 55.0,),

                        const Text(
                          " ∎  Digital carbon generated for 7 days",
                          style: TextStyle(fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                            width: double.infinity, height: 250,
                            margin: const EdgeInsets.only(top: 10, bottom: 25),
                            child: AspectRatio(
                              aspectRatio: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 28,
                                  top: 22,
                                  bottom: 12,
                                ),
                                child: LineChart(
                                  LineChartData(
                                    lineTouchData: const LineTouchData(
                                      enabled: true,),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: List.generate(
                                            7,
                                            (i) {
                                              return FlSpot(i.toDouble(), double.parse(carbonWeeklyStats[i]["dayCarbonUsage"]));
                                            }
                                        ), //MyLineChart.lineChartBarData,
                                        isCurved: true,
                                        barWidth: 4,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.lime,
                                            Colors.yellowAccent,
                                            Colors.redAccent
                                          ],
                                        ),
                                        isStrokeCapRound: true,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.purpleAccent.withOpacity(0.7),
                                          cutOffY: targetCarbon,
                                          applyCutOffY: true,
                                        ),
                                        aboveBarData: BarAreaData(
                                          show: true,
                                          color: Colors.greenAccent.withOpacity(0.7),
                                          cutOffY: targetCarbon,
                                          applyCutOffY: true,
                                        ),
                                        dotData: const FlDotData(
                                          show: false,
                                        ),
                                      ),
                                    ],
                                    minY: 0,
                                    titlesData: FlTitlesData(
                                      show: true,
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 18,
                                          interval: 1,
                                          getTitlesWidget: (meta, Title) {
                                            return LineBottomTitles(
                                                meta, Title, yesterday);
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 18,
                                          interval: 1,
                                          getTitlesWidget: (meta, Title) {
                                            return LineLeftTitles(
                                                meta, Title, targetCarbon);
                                          },
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                          color: MyColors.brightGreenBlue,
                                          width: 2.0
                                      ),
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      verticalInterval: 1,
                                      horizontalInterval: 1,
                                      getDrawingHorizontalLine: (double value) {
                                        return const FlLine(
                                            color: Colors.red,
                                            strokeWidth: 2
                                        );
                                      },
                                      checkToShowHorizontalLine: (double value) {
                                        return value == carbonBaseValue;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Tab2
            Container(
              color: MyColors.deepGreenBlue,
              padding: const EdgeInsets.all(10.0),

              child: Container(
                width: double.infinity, height: 800,
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: MyColors.brightGreenBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 410,
                        child: Text(
                            'Carbon Footprint Ranking',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            itemCount: walingRanking.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  elevation: 1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(20, 20))),

                                  child: GestureDetector(
                                    //onTap: () => cardClickEvent(context, walingRanking[index]),
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      //margin: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Colors.lime, Colors.purpleAccent, Colors.blue],
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      // Adds a gradient background and rounded corners to the container
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 5,),
                                                  Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 5.0,  // shadow blur
                                                          color: Colors.white, // shadow color
                                                          offset: Offset(0,0), // how much shadow will be shown
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15,),
                                                  Text(
                                                      '${walingRanking[index]["id"]}',
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Colors.white)
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                      '${walingRanking[index]["walkingTime"]}',
                                                      style: const TextStyle(
                                                        fontSize: 21.0,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        color: Colors.white,
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
                    Container(
                      width: 400, height: 100,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.lime, Colors.purpleAccent, Colors.blue],
                        ),
                        //color: Colors.lime,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(1, 1))
                        ],

                      ),

                      child: Center(
                          child: Text(
                              'Better than yesterday! Keep going',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
*/