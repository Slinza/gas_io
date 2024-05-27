import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:gas_io/components/bar_element.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/month_line_chart.dart';
//import 'package:gas_io/components/expense_type_pie.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/components/bar_graph.dart';
import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/design/styles.dart';

// import 'package:gas_io/components/line_chart.dart';

class StatsScreen extends StatefulWidget {
  int selectedCarId;
  double averageConsumption = 0;
  StatsScreen({Key? key, required this.selectedCarId}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<FlSpot> yearPrices = [];
  List<BarElement> sixMonthsPrices = [];
  List<FlSpot> averageYearPrices = [];
  List<FlSpot> monthPrices = [];
  List<PieChartSectionData> pieYearData = [];
  CarData carDetails = defaultCarData;
  double averageConsumption = 0.0;
  double totalKmDone = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void didUpdateWidget(covariant StatsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCarId != oldWidget.selectedCarId) {
      _loadCards();
    }
  }

  Future<void> _loadCards() async {
    List<CardData> sixMonthsCard = await _databaseHelper.geSixMonthsCard(
        widget.selectedCarId); // TODO make it taking the auto context
    List<CardData> monthCards = await _databaseHelper.getMonthCard(
        widget.selectedCarId); // TODO make it taking the auto context

    Map<String, dynamic> carData =
        await _databaseHelper.getCarDetailsById(widget.selectedCarId);

    setState(
      () {
        _prepareSixMonthsGraphData(sixMonthsCard);
        _prepareMonthGraphData(monthCards);
        _prepareMonthStatsData(monthCards);
        _getCarInitialKm(carData);
      },
    );
  }

  void _prepareSixMonthsGraphData(List<CardData> cards) {
    sixMonthsPrices = sixMonthsElementsList(cards);
  }

  void _prepareMonthGraphData(List<CardData> cards) {
    monthPrices = monthlyPrice(cards);
  }

  void _prepareMonthStatsData(List<CardData> cards) {
    totalKmDone = getTotalKm(cards, carDetails.initialKm);
    averageConsumption = getAverageConsuption(cards, carDetails.initialKm);
  }

  void _getCarInitialKm(carData) {
    carDetails = CarData.fromMap(carData);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: <Widget>[
        const SizedBox(height: 20.0),
        Container(
          height: 240,
          padding: const EdgeInsets.all(10),
          decoration: statsContainerDecoration,
          child: BarGraph(
            sixMonthsSummary: sixMonthsPrices,
          ),
        ),
        const SizedBox(height: 30.0),
        Container(
          height: 280,
          padding: const EdgeInsets.all(15),
          decoration: statsContainerDecoration,
          child: MonthLineChartWidget(
            monthData: monthPrices,
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          height: 100,
          padding: const EdgeInsets.all(15),
          decoration: statsContainerDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Monthly Distance [km]',
                    style: cardStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Consumption [l/100km]',
                    style: cardStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    totalKmDone.toStringAsFixed(2),
                    style: cardStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    averageConsumption.toStringAsFixed(2),
                    style: cardStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
