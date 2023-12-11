import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class MonthLineChartWidget extends StatelessWidget {
  const MonthLineChartWidget({
    super.key,
    required this.monthData,
  });

  final List<FlSpot> monthData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: monthData,
            isCurved: true,
            barWidth: 3,
            color: Colors.orange,
          ),
        ],
        borderData: FlBorderData(show: true),
        // borderData: FlBorderData(
        //     border: const Border(bottom: BorderSide(), left: BorderSide())),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          leftTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: true, reservedSize: 45, interval: 30)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}
