import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';

class RefuelScreen extends StatefulWidget {
  @override
  _RefuelScreenState createState() => _RefuelScreenState();
}

class _RefuelScreenState extends State<RefuelScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
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
        child: Icon(Icons.add),
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
          margin: EdgeInsets.all(8.0),
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

  // void _addNewCard() {
  //   // You can implement logic to add a new card, for now, let's add a dummy card
  //   setState(() {
  //     _cardList.add(CardData(
  //       price: 50.0,
  //       liters: 30.0,
  //       date: '2023-11-27',
  //       location: 'Gas Station',
  //       euroPerLiter: 1.67,
  //     ));
  //   });
  // }
}

class CardData {
  final double price;
  final double liters;
  final String date;
  final String location;
  final double euroPerLiter;

  CardData({
    required this.price,
    required this.liters,
    required this.date,
    required this.location,
    required this.euroPerLiter,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'liters': liters,
      'date': date,
      'location': location,
      'euroPerLiter': euroPerLiter,
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      price: map['price'],
      liters: map['liters'],
      date: map['date'],
      location: map['location'],
      euroPerLiter: map['euroPerLiter'],
    );
  }
}
