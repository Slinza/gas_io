import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';

class RefuelScreen extends StatefulWidget {
  const RefuelScreen({Key? key}) : super(key: key);

  @override
  _RefuelScreenState createState() => _RefuelScreenState();
}

class _RefuelScreenState extends State<RefuelScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<CardData> _cardList = [];
  final ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<CardData> cards = await _databaseHelper.getCards();
    setState(() {
      _cardList = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewCard();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewCard() async {
    // Generate random values for the new card
    final random = Random();
    CardData newCard = CardData(
      id: DateTime.now().millisecondsSinceEpoch,
      price: (random.nextDouble() * 100).roundToDouble(),
      liters: (random.nextDouble() * 50).roundToDouble(),
      date: DateTime.now().toString(),
      location: 'Random Location',
      euroPerLiter: (random.nextDouble() * 3).roundToDouble(),
    );

    // Insert the new card at the beginning of the list
    _cardList.insert(0, newCard);

    // Save the updated list to the database
    await _databaseHelper.insertCard(newCard);

    // Update the UI with the new list
    setState(() {});

    // Scroll to the top when a new card is added
    _listController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildCardList() {
    return ListView.builder(
      controller: _listController,
      itemCount: _cardList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Price: ${_cardList[index].price} €'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Liters: ${_cardList[index].liters} L'),
                Text('Date: ${_cardList[index].date}'),
                Text('Location: ${_cardList[index].location}'),
                Text('€/L: ${_cardList[index].euroPerLiter} €/L'),
              ],
            ),
          ),
        );
      },
    );
  }
}
