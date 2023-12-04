import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:gas_io/screens/refuel_insert_form.dart';
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
    double euroPerLiter = 1.568 + random.nextDouble() * (2.134 - 1.568);
    double liters = 10 + random.nextDouble() * (60 - 10);
  CardData newCard = CardData(
    id: DateTime.now().millisecondsSinceEpoch,
    price: liters * euroPerLiter,
    liters: liters,
    date: DateTime.now().toString(),
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
          child: RefuelCard(refuelData: cardData)
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


// class RefuelForm extends StatefulWidget {
//   const RefuelForm({Key? key}) : super(key: key);
//
//   @override
//   RefuelFormState createState() {
//     return RefuelFormState();
//   }
// }
//
// class RefuelFormState extends State<RefuelForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Create text controllers for each field in CardData
//   final priceController = TextEditingController();
//   final litersController = TextEditingController();
//   final dateController = TextEditingController();
//   final locationController = TextEditingController();
//   final euroPerLiterController = TextEditingController();
//
//   @override
//   void dispose() {
//     priceController.dispose();
//     litersController.dispose();
//     dateController.dispose();
//     locationController.dispose();
//     euroPerLiterController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Row for Price and Liters
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                     child: TextFormField(
//                       controller: priceController,
//                       decoration: const InputDecoration(
//                         labelText: 'Price',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a price';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                     child: TextFormField(
//                       controller: litersController,
//                       decoration: const InputDecoration(
//                         labelText: 'Liters',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter liters';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             // Date and Time Picker
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: TextFormField(
//                 controller: dateController,
//                 decoration: const InputDecoration(
//                   labelText: 'Date',
//                   border: OutlineInputBorder(),
//                 ),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//
//                   if (pickedDate != null) {
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//
//                     if (pickedTime != null) {
//                       DateTime pickedDateTime = DateTime(
//                         pickedDate.year,
//                         pickedDate.month,
//                         pickedDate.day,
//                         pickedTime.hour,
//                         pickedTime.minute,
//                       );
//
//                       dateController.text = pickedDateTime
//                           .toString(); // Store the formatted date in the text controller
//                     }
//                   }
//                 },
//               ),
//             ),
//
//             // Map for Location
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: TextFormField(
//                 controller: locationController,
//                 decoration: const InputDecoration(
//                   labelText: 'Location',
//                   border: OutlineInputBorder(),
//                 ),
//                 onTap: () async {
//                   // Show a modal bottom sheet or navigate to a map page to select the location
//                   await showModalBottomSheet(
//                     context: context,
//                     builder: (context) {
//                       // Replace this with your actual map selection widget
//                       return Container(
//                         height: 200,
//                         child: const Center(
//                           child: Text('Map Placeholder'),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // If the form is valid, create a new CardData object
//                     CardData newCard = CardData(
//                       id: DateTime.now().millisecondsSinceEpoch,
//                       price: double.parse(priceController.text),
//                       liters: double.parse(litersController.text),
//                       date: dateController.text,
//                       location: locationController.text,
//                       euroPerLiter: double.parse(priceController.text) /
//                           double.parse(litersController.text),
//                     );
//
//                     // saveNewCard(CardData)
//
//                     // Display entered values in an AlertDialog
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           content: Column(
//                             children: [
//                               Text('Price: ${newCard.price}'),
//                               Text('Liters: ${newCard.liters}'),
//                               Text('Date: ${newCard.date}'),
//                               Text('Location: ${newCard.location}'),
//                               Text('EuroPerLiter: ${newCard.euroPerLiter}'),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//                 child: const Text('Submit'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
