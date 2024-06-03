import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/bar_element.dart';
import 'package:gas_io/components/bar_data.dart';
import 'package:gas_io/components/refuel_card.dart';

const int monthsNumber = 12;
const int monthDays = 31;
const int yearFactor = 8;
const int sixMonthFactor = 3;
const int approximationFactor = 10;
const int monthFactor = 3;

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

List<BarElement> sixMonthsElementsList(List<CardData> list) {
  // Map the data to Bar element and reverese the list to have the oldest values as first ones
  return list
      .map((e) => BarElement(x: e.date.month, y: e.price))
      .toList()
      .reversed
      .toList();
}

List<FlSpot> averageYearlyPrice(List<CardData> data) {
  return List.generate(
    monthsNumber,
    (index) {
      return FlSpot(
          index.toDouble() + 1, roundedNumber(average(pricesList(data))));
    },
  );
}

Map<int, double> mapOfDailyPrices(List<CardData> objects) {
  Map<int, double> resultMap = {};

  for (var obj in objects) {
    if (resultMap.containsKey(obj.date.day)) {
      if (resultMap[obj.date.day] != null) {
        resultMap.update(obj.date.day, (value) => value + obj.price);
      }
    } else {
      resultMap[obj.date.day] = obj.price;
    }
  }

  return resultMap;
}

List<FlSpot> monthlyPrice(List<CardData> data) {
  List<FlSpot> monthlyList = [];
  double padding = 0;
  Map<int, double> priceMap = mapOfDailyPrices(data);
  for (int i = 1; i <= 31; i++) {
    if (priceMap.containsKey(i)) {
      padding += priceMap[i] ??= 0;
      monthlyList.add(FlSpot(i.toDouble(), roundedNumber(padding)));
    } else {
      monthlyList.add(FlSpot(i.toDouble(), roundedNumber(padding)));
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

int approximateByFactor(int number, int factor) {
  if (number % factor == 0) {
    return number;
  } else {
    return number + (factor - (number % factor));
  }
}

double roundedNumber(double number, [int decimals = 2]) {
  return double.parse(number.toStringAsFixed(decimals));
}

// Six months expense graph utils
double getUpperLimitSixMonths(BarData data) {
  return approximateByFactor(
          approximateByFactor(data.maxY().ceil(), sixMonthFactor),
          approximationFactor)
      .toDouble();
}

double getIntervalSixMonths(double upperLimit) {
  return roundedNumber((upperLimit / sixMonthFactor), 0).toDouble();
}

// Monthly expense graph utils
double getUpperLimitMonth(List<FlSpot> monthData) {
  int max = findMaxY(monthData);
  return approximateByFactor(
          approximateByFactor(max, monthFactor), approximationFactor)
      .toDouble();
}

double getIntervalMonth(double upperLimit) {
  return roundedNumber((upperLimit / monthFactor), 0).toDouble();
}

// Monthly stats
double getTotalKm(List<CardData> data, [double initialKm = 0.0]) {
  if (data.isNotEmpty) {
    if (data.last.km == data.first.km) {
      return data.last.km - initialKm;
    } else {
      return data.last.km - data.first.km;
    }
  } else {
    return 0.0;
  }
}

// Basic estimation
double getAverageConsuption(List<CardData> data, [double initialKm = 0.0]) {
  double totalDistanceTraveled = getTotalKm(data, initialKm);
  double totalFuelConsumed = data.fold(0, (t, e) => t + e.liters);

  // Calculate average fuel consumption per unit distance
  // Consumption in liters per 100 km
  if (totalDistanceTraveled == 0.0) {
    return 0.0;
  } else {
    return (totalFuelConsumed / totalDistanceTraveled) * 100;
  }
}
