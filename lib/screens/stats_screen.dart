import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/month_line_chart.dart';
import 'package:gas_io/components/year_line_chart.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/utils/support_functions.dart';
import 'package:gas_io/utils/database_helper.dart';

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
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 250,
          color: Colors.amber[800],
          child: MonthLineChartWidget(
            monthData: monthPrices,
          ),
        ),
        Container(
          height: 230,
          color: Colors.amber[500],
          child: YearLineChartWidget(
            monthData: yearPrices,
            average: averageYearPrices,
          ),
        ),
        Container(
          height: 200,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
  }
}
