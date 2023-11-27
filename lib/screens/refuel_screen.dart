import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';

class RefuelScreen extends StatefulWidget {
  const RefuelScreen({super.key});

  @override
  _RefuelScreenState createState() => _RefuelScreenState();
}

class _RefuelScreenState extends State<RefuelScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<CardData> _cardList = [];

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
    // Display a form or dialog to get user input for a new card
    // For now, let's add a dummy card
    CardData newCard = CardData(
      price: 60.0,
      liters: 40.0,
      date: '2023-11-28',
      location: 'Gas Station 2',
      euroPerLiter: 1.50,
    );

    // Insert the new card into the database
    await _databaseHelper.insertCard(newCard);

    // Reload the cards from the database
    await _loadCards();
  }

  Widget _buildCardList() {
    return ListView.builder(
      reverse: true,
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
