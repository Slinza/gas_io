import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/design/themes.dart';

class YearLineChartWidget extends StatelessWidget {
  const YearLineChartWidget({
    super.key,
    required this.monthData,
    required this.average,
  });

  final List<FlSpot> monthData;
  final List<FlSpot> average;

  @override
  Widget build(BuildContext context) {
    double upperLimit = getUpperLimitMonth(monthData);
    double interval = getIntervalMonth(upperLimit);
    return LineChart(
      LineChartData(
        lineBarsData: [
          // The red line
          LineChartBarData(
            spots: monthData,
            isCurved: true,
            barWidth: 3,
            color: primaryColor,
          ),
          // The orange line
          LineChartBarData(
            spots: average,
            isCurved: true,
            barWidth: 3,
            color: redColor,
          ),
        ],
        minY: 0,
        maxY: upperLimit,
        borderData: FlBorderData(show: false),
        // borderData: FlBorderData(
        //     border: const Border(bottom: BorderSide(), left: BorderSide())),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: interval <= 0.0 ? 1 : interval),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Jan';
              break;
            case 3:
              text = 'Mar';
              break;
            case 5:
              text = 'May';
              break;
            case 7:
              text = 'Jul';
              break;
            case 9:
              text = 'Sep';
              break;
            case 11:
              text = 'Nov';
              break;
          }

          return Text(text);
        },
      );
}
