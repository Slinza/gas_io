import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:gas_io/components/refuel_card.dart';

double average(List<double> data) {
  if (data.isNotEmpty) {
    return (data.reduce((a, b) => a + b)) / data.length;
  } else {
    return 0;
  }
}

double averagePrice(List<CardData> data) {
  return data.map((m) => m.price).reduce((a, b) => a + b) / data.length;
}

List<FlSpot> lineDataGenerator(List<CardData> data, [double? defaultValue]) {
  if (defaultValue == null) {
    return List.generate(
      12,
      (index) {
        return FlSpot(index.toDouble() + 1, index * Random().nextDouble());
      },
    );
  } else {
    return List.generate(
      12,
      (index) {
        return FlSpot(index.toDouble() + 1, defaultValue);
      },
    );
  }
}
