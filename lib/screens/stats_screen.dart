import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/month_line_chart.dart';
//import 'package:gas_io/components/expense_type_pie.dart';
import 'package:gas_io/components/year_line_chart.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/design/styles.dart';

// import 'package:gas_io/components/line_chart.dart';

class StatsScreen extends StatefulWidget {
  StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // StatsScreen({super.key, required this.cardList});
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<FlSpot> yearPrices = [];
  List<FlSpot> averageYearPrices = [];
  List<FlSpot> monthPrices = [];
  List<PieChartSectionData> pieYearData = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<CardData> yearCards = await _databaseHelper.getYearCard();
    List<CardData> monthCards = await _databaseHelper.getMonthCard();
    setState(() {
      _prepareYearGraphData(yearCards);
      _prepareMonthGraphData(monthCards);
      pieYearData = [
        PieChartSectionData(
            //value: 10,
            radius:
                100), //TODO: add real values once the type of the expense will be introduced
      ];
    });
  }

  void _prepareYearGraphData(List<CardData> cards) {
    yearPrices = pricesYearlyList(cards);
    averageYearPrices = averageYearlyPrice(cards);
  }

  void _prepareMonthGraphData(List<CardData> cards) {
    monthPrices = monthlyPrice(cards);
  }

  @override
  Widget build(BuildContext context) {
    //print(monthData);
    return ListView(
      padding: const EdgeInsets.all(10),
      children: <Widget>[
        SizedBox(height: 40.0),
        const Text(
          "Expense of the month",
          style: subtitleTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.0),
        Container(
          height: 250,
          // color: Colors.amber[800],
          child: MonthLineChartWidget(
            monthData: monthPrices,
          ),
        ),
        SizedBox(height: 50.0),
        const Text(
          "Yearly consume trend",
          style: subtitleTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.0),
        Container(
          height: 230,
          // color: Colors.amber[500],
          child: YearLineChartWidget(
            monthData: yearPrices,
            average: averageYearPrices,
          ),
        ),
        SizedBox(height: 16.0),
        // Container(
        //   height: 100,
        //   color: Colors.amber[100],
        //   child: YearPieChartWidget(pieData: pieYearData),
        // ),
      ],
    );
  }
}
