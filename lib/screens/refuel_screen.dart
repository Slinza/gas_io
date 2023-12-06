import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:gas_io/screens/refuel_insert_form.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      price: liters * euroPerLiter,
      liters: liters,
      date: DateTime.now(),
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(

              // Specify a key if the Slidable is dismissible.
              key: Key(cardData.id.toString()),

              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                extentRatio: 0.5,
                motion: const BehindMotion(),
                // dismissible: DismissiblePane(onDismissed: () async {
                //   await _databaseHelper.deleteCard(cardData);
                //   setState(() {
                //     _cardList.removeAt(index);
                //   });
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Card dismissed'),
                //     ),
                //   );
                // }),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    onPressed: (context) {},
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.green,
                    icon: Icons.edit,
                    label: 'Edit',
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                  SlidableAction(
                    onPressed: (context) async {
                      await _databaseHelper.deleteCard(cardData);
                      setState(() {
                        _cardList.removeAt(index);
                      });
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('Card dismissed'),
                      //   ),
                      // );
                    },
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.red,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),

                  // Container(
                  //   height: 10,
                  //   width: 60,
                  //   decoration: BoxDecoration(
                  //     color: Colors.red,
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(10),
                  //       bottomLeft: Radius.circular(10),
                  //     ),
                  //   ),
                  // )
                ],
              ),

              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: RefuelCard(refuelData: cardData)),
        );
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
