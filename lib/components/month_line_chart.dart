import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/design/themes.dart';

const int INTERVAL_FACTOR = 3;

class MonthLineChartWidget extends StatelessWidget {
  const MonthLineChartWidget({
    super.key,
    required this.monthData,
  });

  final List<FlSpot> monthData;

  @override
  Widget build(BuildContext context) {
    double upperLimit = getUpperLimitMonth(monthData);
    double interval = getIntervalMonth(upperLimit);
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: monthData,
            isCurved: false,
            color: primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withOpacity(0.2),
            ),
          ),
        ],
        minY: 0,
        maxY: upperLimit,
        //maxX: 33,
        borderData: FlBorderData(
            show: true,
            border: const Border(bottom: BorderSide(), left: BorderSide())),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: false, reservedSize: 30, interval: 3),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 37,
              interval: interval <= 0.0 ? 1 : interval,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}

double getUpperLimitMonth(List<FlSpot> monthData) {
  int max = findMaxY(monthData);
  return approximateByFactor(approximateByFactor(max, INTERVAL_FACTOR), 10)
      .toDouble();
}

double getIntervalMonth(double upperLimit) {
  return (upperLimit / INTERVAL_FACTOR).toDouble();
}
