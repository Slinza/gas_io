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

  List<CardData> _cardList = [];
  List<double> _prices = [];
  List<FlSpot> monthData = [];
  List<FlSpot> avedragePrice = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<CardData> cards = await _databaseHelper.getCards();
    setState(() {
      _cardList = cards;
      _prepareGraphData(cards);
    });
  }

  void _prepareGraphData(List<CardData> cards) {
    _prices = pricesList(cards);
    monthData = lineDataGenerator(_prices);
    avedragePrice = lineDataGenerator([], average(_prices));
  }

  @override
  Widget build(BuildContext context) {
    print("---------------------------");
    print(_prices);
    print(monthData);
    print(avedragePrice);
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
          height: 200,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
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
