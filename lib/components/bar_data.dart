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

  // List<BarElement> barData = [];

  // void initializeBarData() {
  //   barData = [
  //     BarElement(x: 0, y: firstMonthAmount),
  //     BarElement(x: 1, y: secondMonthAmount),
  //     BarElement(x: 2, y: thirdMonthAmount),
  //     BarElement(x: 3, y: fourthMonthAmount),
  //     BarElement(x: 4, y: fifthMonthAmount),
  //     BarElement(x: 5, y: actualMonthAmount),
  //   ];
  // }
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
}
