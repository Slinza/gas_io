import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    super.key,
    required this.monthData,
    required this.average,
  });

  final List<FlSpot> monthData;
  final List<FlSpot> average;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          // The red line
          LineChartBarData(
            spots: monthData,
            isCurved: true,
            barWidth: 3,
            color: Colors.indigo,
          ),
          // The orange line
          LineChartBarData(
            spots: average,
            isCurved: true,
            barWidth: 3,
            color: Colors.red,
          ),
        ],
        borderData: FlBorderData(show: false),
        // borderData: FlBorderData(
        //     border: const Border(bottom: BorderSide(), left: BorderSide())),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
