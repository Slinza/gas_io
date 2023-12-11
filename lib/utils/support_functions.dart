import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/refuel_card.dart';

const int monthsNumber = 12;

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

List<double> pricesList(List<CardData> list) {
  return list.map((e) => e.price).toList();
}

List<FlSpot> pricesMonthlyList(List<CardData> list) {
  return list.map((e) => FlSpot(e.date.month.toDouble(), e.price)).toList();
}

List<FlSpot> averageMonthlyPrice(List<CardData> data) {
  return List.generate(
    monthsNumber,
    (index) {
      return FlSpot(index.toDouble() + 1, average(pricesList(data)));
    },
  );
}
