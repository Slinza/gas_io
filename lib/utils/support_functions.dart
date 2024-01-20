import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/refuel_card.dart';

const int monthsNumber = 12;
const int monthDays = 31;

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

List<FlSpot> pricesYearlyList(List<CardData> list) {
  return list.map((e) => FlSpot(e.date.month.toDouble(), e.price)).toList();
}

List<FlSpot> averageYearlyPrice(List<CardData> data) {
  return List.generate(
    monthsNumber,
    (index) {
      return FlSpot(index.toDouble() + 1, average(pricesList(data)));
    },
  );
}

Map<int, double> mapOfDailyPrices(List<CardData> objects) {
  Map<int, double> resultMap = {};

  objects.forEach(
    (obj) {
      if (resultMap.containsKey(obj.date.day)) {
        if (resultMap[obj.date.day] != null)
          resultMap.update(obj.date.day, (value) => value + obj.price);
      } else {
        resultMap[obj.date.day] = obj.price;
      }
    },
  );

  return resultMap;
}

List<FlSpot> monthlyPrice(List<CardData> data) {
  List<FlSpot> monthlyList = [];
  double padding = 0;
  Map<int, double> priceMap = mapOfDailyPrices(data);
  for (int i = 1; i <= 31; i++) {
    if (priceMap.containsKey(i)) {
      padding += priceMap[i] ??= 0;
      monthlyList.add(FlSpot(i.toDouble(), padding));
    } else {
      monthlyList.add(FlSpot(i.toDouble(), padding));
    }
  }
  return monthlyList;
}

int findMaxY(List<FlSpot> data) {
  int max = 0;
  for (final spot in data) {
    if (spot.y > max) {
      max = (spot.y).ceil();
    }
  }
  return max;
}

int approximateToNextDivisibleByFactor(int number, int factor) {
  if (number % factor == 0) {
    return number;
  } else {
    return number + (factor - (number % factor));
  }
}
