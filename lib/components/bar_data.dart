import 'package:gas_io/components/bar_element.dart';

class BarData {
  final BarElement firstMonthAmount;
  final BarElement secondMonthAmount;
  final BarElement thirdMonthAmount;
  final BarElement fourthMonthAmount;
  final BarElement fifthMonthAmount;
  final BarElement actualMonthAmount;

  BarData({
    required this.firstMonthAmount,
    required this.secondMonthAmount,
    required this.thirdMonthAmount,
    required this.fourthMonthAmount,
    required this.fifthMonthAmount,
    required this.actualMonthAmount,
  });

  List<BarElement> barData = [];

  void initializeBarData() {
    barData = [
      firstMonthAmount,
      secondMonthAmount,
      thirdMonthAmount,
      fourthMonthAmount,
      fifthMonthAmount,
      actualMonthAmount,
    ];
  }

  double maxY() {
    barData = [
      firstMonthAmount,
      secondMonthAmount,
      thirdMonthAmount,
      fourthMonthAmount,
      fifthMonthAmount,
      actualMonthAmount,
    ];
    double max = 0;
    if (barData.isEmpty) {
      return 0.0;
    } else {
      for (final spot in barData) {
        if (spot.y > max) {
          max = spot.y;
        }
      }
      return max;
    }
  }
}
