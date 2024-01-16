import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';

// TODO: tmp function
DateTime generateRandomDateTime() {
  Random random = Random();

// Get the current year
  int currentYear = DateTime.now().year;

// Generate a random number between 0 to 365 (number of days in a year)
  int randomDays = random.nextInt(365);

// Subtract the random number of days from the start of the current year to get a random DateTime in the past year
  DateTime randomDateTime =
      DateTime(currentYear, 12, 31).subtract(Duration(days: randomDays));
  return randomDateTime;
}

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
    double euroPerLiter = 1.568 + random.nextDouble() * (2.134 - 1.568);
    double liters = 10 + random.nextDouble() * (60 - 10);
    CardData newCard = CardData(
      id: DateTime.now().millisecondsSinceEpoch,
      carId: 0, // TODO: connect to local user and car ID
      price: liters * euroPerLiter,
      liters: liters,
      date:
          generateRandomDateTime(), //DateTime.now(), // TODO: Remove the random DateTime generation
      location: 'Random Location',
      euroPerLiter: euroPerLiter,
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
        final CardData cardData = _cardList[index];
        return Dismissible(
            key: Key(cardData.id.toString()),
            onDismissed: (direction) async {
              await _databaseHelper.deleteCard(cardData);
              setState(() {
                _cardList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Card dismissed'),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: AlignmentDirectional.centerStart,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: RefuelCard(refuelData: cardData));
      },
    );
  }

  // void _addNewCard() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // Return a widget for the bottom sheet content
  //       return _buildBottomSheetContent();
  //     },
  //   );
  // }

  // Widget _buildBottomSheetContent() {
  //   return const RefuelForm();
  //   // return Container(
  //   //   padding: EdgeInsets.all(16.0),
  //   //   height: MediaQuery.of(context).size.height * 2 / 3,
  //   //   child: Column(
  //   //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //   //     children: [
  //   //       // Price Field
  //   //       TextFormField(
  //   //         decoration: InputDecoration(labelText: 'Price'),
  //   //         keyboardType: TextInputType.number,
  //   //         onChanged: (value) {
  //   //           // newCard.price = double.parse(value);
  //   //         },
  //   //       ),
  //
  //   //       // Liters Field
  //   //       TextFormField(
  //   //         decoration: InputDecoration(labelText: 'Liters'),
  //   //         keyboardType: TextInputType.number,
  //   //         onChanged: (value) {
  //   //           // newCard.liters = double.parse(value);
  //   //         },
  //   //       ),
  //
  //   //       // Date Field
  //   //       TextFormField(
  //   //         decoration: InputDecoration(labelText: 'Date'),
  //   //         onChanged: (value) {
  //   //           // newCard.date = value;
  //   //         },
  //   //       ),
  //
  //   //       // Location Field
  //   //       TextFormField(
  //   //         decoration: InputDecoration(labelText: 'Location'),
  //   //         onChanged: (value) {
  //   //           // newCard.location = value;
  //   //         },
  //   //       ),
  //
  //   //       // EuroPerLiter Field
  //   //       TextFormField(
  //   //         decoration: InputDecoration(labelText: 'EuroPerLiter'),
  //   //         keyboardType: TextInputType.number,
  //   //         onChanged: (value) {
  //   //           // newCard.euroPerLiter = double.parse(value);
  //   //         },
  //   //       ),
  //
  //   //       // Save Button
  //   //       ElevatedButton(
  //   //         onPressed: () {
  //   //           CardData newCard = CardData(
  //   //             id: DateTime.now().millisecondsSinceEpoch,
  //   //             price: (100).roundToDouble(),
  //   //             liters: (50).roundToDouble(),
  //   //             date: DateTime.now().toString(),
  //   //             location: 'Random Location',
  //   //             euroPerLiter: (3).roundToDouble(),
  //   //           );
  //   //           // Save the new card and close the bottom sheet
  //   //           _saveNewCard(newCard);
  //   //         },
  //   //         child: Text('Save'),
  //   //       ),
  //
  //   //       // Cancel Button
  //   //       TextButton(
  //   //         onPressed: () {
  //   //           // Close the bottom sheet
  //   //           Navigator.of(context).pop();
  //   //         },
  //   //         child: Text('Cancel'),
  //   //       ),
  //   //     ],
  //   //   ),
  //   // );
  // }

  void saveNewCard(newCard) async {
    // Perform the necessary logic to save the new card
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

    // Close the bottom sheet
    Navigator.of(context).pop();

    // Add any additional logic you need after saving the new card
  }
}
