import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:vertical_barchart/vertical-barchart.dart';

import '../services/mychart.dart';
import '../services/mycolor.dart';

class CarbonFootprint extends StatefulWidget {
  const CarbonFootprint({super.key});

  @override
  State<CarbonFootprint> createState() => _CarbonFootprintState();
}

class _CarbonFootprintState extends State<CarbonFootprint> {
  int pieTouchedIndex = 0;
  int barTouchedIndex = 0;
  double targetCarbon = 5.0;

  double barWidth = 20;
  double barShadowOpacity = 0.4;

  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
  ];
  List<String> itemContents = [
    'Item 1 Contents',
    'Item 2 Contents',
    'Item 3 Contents',
    'Item 4 Contents',
    'Item 5 Contents',
    'Item 6 Contents',
    'Item 7 Contents',
    'Item 8 Contents',
  ];

  void cardClickEvent(BuildContext context, int index) {
    String content = itemContents[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentPage(content: content),
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
                            Spacer(),
                            Text(
                              "\ndate: ${DateFormat('MM.dd').format(
                                  yesterday)}\nreporter: SGreenTime",
                              style: const TextStyle(fontSize: 9.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35.0,),
                        const Text(
                          " What's the biggest cause of digital carbon?",
                          style: TextStyle(fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 80,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: 90, height: 90,
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
                                            shortestSide, pieTouchedIndex),
                                      ),
                                    );
                                  }
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '''The biggest cause is 
                          \ninstagram.
                          \nadvice: how about turn off
                          \nalarm of instagram?''',
                              style: TextStyle(fontSize: 9.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                        const Spacer(),
                        //SizedBox(height: 80,),

                        const Text(
                          " How much daily digital carbon amount changes?",
                          style: TextStyle(fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
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
                                barGroups: MyBarChart.barMainItems.entries
                                    .map(
                                      (e) =>
                                      MyBarChart.generateBarGroup(
                                        e.key,
                                        e.value,
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
                          " How much digital carbon generated for 7 days?",
                          style: TextStyle(fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
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
                                        spots: MyLineChart.lineChartBarData,
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
                                        return value == targetCarbon;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ),
                        const Text(
                          '''     for 5 days, screen time goal was successfully achieved!
                      \n     but for 2 days, failed.
                      ''',
                          style: TextStyle(fontSize: 9.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Tab2
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Container(
                    width: 410,
                    child: Text(
                        ' Ranking',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(20, 20))),

                              child: GestureDetector(
                                onTap: () => cardClickEvent(context, index),
                                child: Container(
                                  height: 70,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  //margin: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF846AFF),
                                          Color(0xFF755EE8),
                                          Colors.purpleAccent,
                                          Colors.amber,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  // Adds a gradient background and rounded corners to the container
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  '${index + 1} nickname',
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.white)
                                              ),
                                              const Spacer(),
                                              Text(
                                                  '100',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.white)
                                              ),
                                              /*
                                                Stack(
                                                  children: List.generate(
                                                    2,
                                                        (index) => Container(
                                                      margin: EdgeInsets.only(left: (15 * index).toDouble()),
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white54),
                                                    ),
                                                  ),
                                                ) // Adds a stack of two circular containers to the right of the title
                                                */
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