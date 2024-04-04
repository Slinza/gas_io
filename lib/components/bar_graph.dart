import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:gas_io/components/bar_data.dart';
import 'package:gas_io/components/bar_element.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';
import 'package:gas_io/utils/support_functions.dart';

class BarGraph extends StatelessWidget {
  final List sixMonthsSummary;
  const BarGraph({
    super.key,
    required this.sixMonthsSummary,
  });

  @override
  Widget build(BuildContext context) {
    BarData currentBarData = BarData(
      firstMonthAmount: BarElement(x: 0, y: 0.0),
      secondMonthAmount: BarElement(x: 1, y: 0.0),
      thirdMonthAmount: BarElement(x: 2, y: 0.0),
      fourthMonthAmount: BarElement(x: 3, y: 0.0),
      fifthMonthAmount: BarElement(x: 4, y: 0.0),
      actualMonthAmount: BarElement(x: 5, y: 0.0),
    );
    if (sixMonthsSummary.isNotEmpty) {
      currentBarData = BarData(
          firstMonthAmount: sixMonthsSummary[0],
          secondMonthAmount: sixMonthsSummary[1],
          thirdMonthAmount: sixMonthsSummary[2],
          fourthMonthAmount: sixMonthsSummary[3],
          fifthMonthAmount: sixMonthsSummary[4],
          actualMonthAmount: sixMonthsSummary[5]);
    }

    currentBarData.initializeBarData();
    double upperLimit = getUpperLimitSixMonths(currentBarData);
    double interval = getIntervalSixMonths(upperLimit);
    return BarChart(BarChartData(
      minY: 0,
      maxY: upperLimit,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: _bottomTitles,
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: interval <= 0.0 ? 1 : interval),
        ),
        topTitles: const AxisTitles(
          axisNameWidget: Text(
            "Last months consume trend",
            style: subtitleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barGroups: currentBarData.barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: primaryColor,
                    width: 25,
                    borderRadius: BorderRadius.circular(4)),
              ],
            ),
          )
          .toList(),
    ));
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Jan';
              break;
            case 2:
              text = 'Feb';
              break;
            case 3:
              text = 'Mar';
              break;
            case 4:
              text = 'Apr';
              break;
            case 5:
              text = 'May';
              break;
            case 6:
              text = 'June';
              break;
            case 7:
              text = 'July';
              break;
            case 8:
              text = 'Aug';
              break;
            case 9:
              text = 'Sep';
              break;
            case 10:
              text = 'Oct';
              break;
            case 11:
              text = 'Nov';
              break;
            case 12:
              text = 'Dec';
              break;
          }

          return Text(text);
        },
      );
}
