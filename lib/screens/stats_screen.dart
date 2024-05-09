import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:gas_io/components/bar_element.dart';
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
  // StatsScreen({super.key, required this.cardList});
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<FlSpot> yearPrices = [];
  List<BarElement> sixMonthsPrices = [];
  List<FlSpot> averageYearPrices = [];
  List<FlSpot> monthPrices = [];
  List<PieChartSectionData> pieYearData = [];
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
    setState(
      () {
        //_prepareYearGraphData(yearCards);
        _prepareSixMonthsGraphData(sixMonthsCard);
        _prepareMonthGraphData(monthCards);
        _prepareMonthStatsData(monthCards);

        pieYearData = [
          PieChartSectionData(
              //value: 10,
              radius:
                  100), //TODO: add real values once the type of the expense will be introduced
        ];
      },
    );
  }

  // void _prepareYearGraphData(List<CardData> cards) {
  //   yearPrices = pricesYearlyList(cards);
  //   averageYearPrices = averageYearlyPrice(cards);
  // }

  void _prepareSixMonthsGraphData(List<CardData> cards) {
    sixMonthsPrices = sixMonthsElementsList(cards);
    //averageYearPrices = averageYearlyPrice(cards);
  }

  void _prepareMonthGraphData(List<CardData> cards) {
    monthPrices = monthlyPrice(cards);
  }

  void _prepareMonthStatsData(List<CardData> cards) {
    totalKmDone = getTotalKm(cards);
    averageConsumption = getAverageConsuption(cards);
  }

  @override
  Widget build(BuildContext context) {
    bool CONDITION =
        true; // TODO evaluate if apply any condition for the last card
    return ListView(
      padding: const EdgeInsets.all(15),
      children: <Widget>[
        const SizedBox(height: 20.0),
        Container(
          height: 280,
          padding: const EdgeInsets.all(15),
          decoration: statsContainerDecoration,
          child: MonthLineChartWidget(
            monthData: monthPrices,
          ),
        ),
        const SizedBox(height: 30.0),
        Container(
          height: 240,
          padding: const EdgeInsets.all(10),
          decoration: statsContainerDecoration,
          child: BarGraph(
            sixMonthsSummary: sixMonthsPrices,
            //monthData: yearPrices,
            //average: averageYearPrices,
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          height: 100,
          padding: EdgeInsets.all(10),
          decoration: statsContainerDecoration,
          child: CONDITION == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total KM done',
                          style: cardStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Average consumption [l/100km]',
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
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Do a full refuel in order to unlock more statistics",
                      style: cardStyle,
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 16.0),
        // Container(
        //   height: 100,
        //   color: Colors.amber[100],
        //   child: YearPieChartWidget(pieData: pieYearData),
        // ),
      ],
    );
  }
}
