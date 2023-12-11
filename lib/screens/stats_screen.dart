import 'package:flutter/material.dart';
//For random
import 'package:fl_chart/fl_chart.dart';
import 'package:gas_io/components/line_chart.dart';
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

  List<FlSpot> monthData = [];
  List<FlSpot> avedragePrice = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<CardData> cards = await _databaseHelper.getCardsByMonth();
    setState(() {
      _prepareGraphData(cards);
    });
  }

  void _prepareGraphData(List<CardData> cards) {
    monthData = pricesMonthlyList(cards);
    avedragePrice = averageMonthlyPrice(cards);
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
          child: LineChartWidget(
            monthData: monthData,
            average: avedragePrice,
          ),
        ),
        Container(
          height: 250,
          color: Colors.amber[500],
          child: LineChartWidget(
            monthData: monthData,
            average: avedragePrice,
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
