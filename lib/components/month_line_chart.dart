import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';

class MonthLineChartWidget extends StatelessWidget {
  const MonthLineChartWidget({
    super.key,
    required this.monthData,
  });

  final List<FlSpot> monthData;

  @override
  Widget build(BuildContext context) {
    double upperLimit = roundedNumber(getUpperLimitMonth(monthData), 0);
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
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withOpacity(0.2),
            ),
          ),
        ],
        minY: 0,
        maxY: upperLimit,
        borderData: FlBorderData(
            show: true,
            border: const Border(bottom: BorderSide(), left: BorderSide())),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(
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
          topTitles: const AxisTitles(
            axisNameWidget: Text(
              "Expense of the month",
              style: subtitleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
      duration:
          const Duration(milliseconds: 0), // Control graph refresh movements
    );
  }
}
