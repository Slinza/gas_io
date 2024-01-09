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
            isCurved: false,
            barWidth: 3,
            color: Colors.amber,
            dotData: FlDotData(show: false),
          ),
        ],
        minY: 0,
        maxX: 31,
        borderData: FlBorderData(
            show: true,
            border: const Border(bottom: BorderSide(), left: BorderSide())),
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
