import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/bar_element.dart';
import 'package:gas_io/components/month_line_chart.dart';
//import 'package:gas_io/components/expense_type_pie.dart';
import 'package:gas_io/components/year_line_chart.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/components/bar_graph.dart';
import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/design/styles.dart';

// import 'package:gas_io/components/line_chart.dart';

class StatsScreen extends StatefulWidget {
  int selectedCarId;
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
    setState(() {
      //_prepareYearGraphData(yearCards);
      _prepareSixMonthsGraphData(sixMonthsCard);
      _prepareMonthGraphData(monthCards);
      pieYearData = [
        PieChartSectionData(
            //value: 10,
            radius:
                100), //TODO: add real values once the type of the expense will be introduced
      ];
    });
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

  @override
  Widget build(BuildContext context) {
    //print(monthData);

    List<BarElement> sixMonthsData = [
      BarElement(x: 4, y: 22.3),
      BarElement(x: 5, y: 44.3),
      BarElement(x: 6, y: 37.3),
      BarElement(x: 7, y: 62.3),
      BarElement(x: 8, y: 55.3),
      BarElement(x: 9, y: 12.3)
    ];

    return ListView(
      padding: const EdgeInsets.all(15),
      children: <Widget>[
        const SizedBox(height: 40.0),
        const Text(
          "Expense of the month",
          style: subtitleTextStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30.0),
        Container(
          height: 250,
          color: Colors.amber[800],
          child: MonthLineChartWidget(
            monthData: monthPrices,
          ),
        ),
        const SizedBox(height: 50.0),
        const Text(
          "Last months consume trend",
          style: subtitleTextStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30.0),
        Container(
          height: 230,
          color: Colors.amber[500],
          child: BarGraph(
            sixMonthsSummary: sixMonthsPrices,
            //monthData: yearPrices,
            //average: averageYearPrices,
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
