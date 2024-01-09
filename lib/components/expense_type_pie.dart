import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class YearPieChartWidget extends StatelessWidget {
  const YearPieChartWidget({
    super.key,
    required this.pieData,
  });

  final List<PieChartSectionData> pieData;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: pieData,
      ),
      // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}
