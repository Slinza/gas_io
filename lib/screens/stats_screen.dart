import 'package:flutter/material.dart';
import 'dart:math'; //For random
import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/line_chart.dart';

// import 'package:gas_io/components/line_chart.dart';

class StatsScreen extends StatelessWidget {
  StatsScreen({Key? key}) : super(key: key);

  final List<FlSpot> monthData = List.generate(12, (index) {
    return FlSpot(index.toDouble() + 1, index * Random().nextDouble());
  });
  final List<FlSpot> avedrage = List.generate(12, (index) {
    return FlSpot(index.toDouble() + 1, 3);
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 200,
          color: Colors.amber[800],
          child: LineChartWidget(
            monthData: monthData,
            average: avedrage,
          ),
        ),
        Container(
          height: 200,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 200,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
  }
}
