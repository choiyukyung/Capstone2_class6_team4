import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

import 'mycolor.dart';

abstract class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  static List<PieChartSectionData> showingSections(List<Map<String, dynamic>> appCarbon, double shortestSide, int pieTouchedIndex) {
    return List.generate(appCarbon.length, (i) { //appInfoYesterday: 데이터 정렬 필요?
      final isTouched = i == pieTouchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = shortestSide / 2; //isTouched ? 65.0 : 60.0;
      final widgetSize = isTouched ? 35.0 : 30.0;
      const widgetOffset = 1.1;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: MyColors.brightGreenBlue,
            value: appCarbon[i]["appCarbon"],
            title: '${appCarbon[i]["appCarbon"]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: PieBadge(
              'assets/icons/instagram.jpeg', //수정 필요
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: widgetOffset,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.lime,
            value: appCarbon[i]["appCarbon"],
            title: '${appCarbon[i]["appCarbon"]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: PieBadge(
              'assets/icons/youtube.jpeg',
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: widgetOffset,
          );
        case 2:
          return PieChartSectionData(
            color: MyColors.brightOrange,
            value: appCarbon[i]["appCarbon"],
            title: '${appCarbon[i]["appCarbon"]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: PieBadge(
              'assets/icons/gmail.jpeg',
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: widgetOffset,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: appCarbon[i]["appCarbon"],
            title: '${appCarbon[i]["appCarbon"]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              //shadows: shadows,
            ),
            badgeWidget: PieBadge(
              'assets/icons/discord.jpeg',
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: widgetOffset,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class PieBadge extends StatelessWidget {
  const PieBadge(
      this.svgAsset, {
        required this.size,
        required this.borderColor,
      });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          svgAsset,
        ),
      ),
    );
  }
}

abstract class MyBarChart extends StatelessWidget {
  List? carbonChange;
  MyBarChart({required this.carbonChange, super.key});

  static bool isShadowBar(int rodIndex) => rodIndex == 1;

  static BarChartGroupData generateBarGroup(
      int x,
      double value1,
      int barTouchedIndex,
      double barWidth,
      double shadowOpacity,
      ) {
    final isTop = value1 > 0;
    final isTouched = barTouchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: value1,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          )
              : const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              isTop ? MyColors.brightOrange : Colors.lime,
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),
        BarChartRodData(
          toY: -value1,
          width: barWidth,
          color: Colors.transparent,
          borderRadius: isTop
              ? const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              -value1,
              MyColors.brightGreenBlue
                  .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
              const BorderSide(color: Colors.transparent),
            ),
          ],
        ),
      ],
    );
  }
}

class BarBottomTitles extends StatelessWidget {
  const BarBottomTitles(
      this.value,
      this.meta, {
        super.key
      });
  final double value;
  final TitleMeta meta;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    switch (value.toInt()) { //수정 필요
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }
}

class BarLeftTitles extends StatelessWidget {
  const BarLeftTitles(
      this.value,
      this.meta, {
        super.key
      });
  final double value;
  final TitleMeta meta;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    return SideTitleWidget(
      //angle: AppUtils().degreeToRadian(value < 0 ? -45 : 45),
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DotLineChart extends StatelessWidget {
  const DotLineChart(this.barData, {super.key});
  final List<VBarChartModel> barData;

  @override
  Widget build(BuildContext context) {
    return VerticalBarchart(
      background: Colors.transparent,
      labelColor: MyColors.mint,
      labelSizeFactor: 0.27,
      tooltipColor: Colors.white70,
      tooltipSize: 80,
      showBackdrop: true,
      backdropColor: MyColors.brightGreenBlue,
      maxX: 150,
      data: barData,
      barStyle: BarStyle.CIRCLE,
    );
  }
}


abstract class MyLineChart extends StatelessWidget {
  const MyLineChart({super.key});
}

class LineBottomTitles extends StatelessWidget {
  const LineBottomTitles(
      this.value,
      this.meta,
      this.yesterday,
      {super.key
      });
  final double value;
  final TitleMeta meta;
  final DateTime yesterday;

  @override
  Widget build(BuildContext context) {
    String text;
    int days = value.toInt();

    if (days <=6){
      text = DateFormat('MM.dd').format(yesterday.subtract(Duration(days: 6-days)));
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class LineLeftTitles extends StatelessWidget {
  const LineLeftTitles(
      this.value,
      this.meta,
      this.targetCarbon,
      {super.key
      });
  final double value;
  final TitleMeta meta;
  final double targetCarbon;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Colors.yellowAccent,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );
    if (value == targetCarbon) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 3,
        child: Text(value.toStringAsFixed(0), style: style),
      );
    } else {
      return Container();
    }
  }
}


abstract class MyRankingChart extends StatelessWidget {
  const MyRankingChart({super.key});

  void cardClickEvent(BuildContext context, int index, List<String> itemContents) {
    String content = itemContents[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(content: content),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  final String content;

  const UserPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content'),
      ),
      body: Center(
        child: Text(content),
      ),
    );
  }
}
