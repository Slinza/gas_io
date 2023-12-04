import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gas_io/screens/refuel_insert_form.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:google_fonts/google_fonts.dart';

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
    double euro_per_liter = 1.568 + random.nextDouble() * (2.134 - 1.568);
    double liters = 10 + random.nextDouble() * (60 - 10);
  CardData newCard = CardData(
    id: DateTime.now().millisecondsSinceEpoch,
    price: liters * euro_per_liter,
    liters: liters,
    date: DateTime.now().toString(),
    location: 'Random Location',
    euroPerLiter: euro_per_liter,
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
        final CardData card = _cardList[index];
        return Dismissible(
          key: Key(card.id.toString()),
          onDismissed: (direction) async {
            await _databaseHelper.deleteCard(card);
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
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat(
                            'EE, dd-MM-yyyy',
                          ).format(DateTime.parse(card.date)),
                          // style: const TextStyle(
                          //   color: Colors.black,
                          //   fontSize: 18,
                          //   fontFamily: 'SevenSegment',
                          //   fontWeight: FontWeight.w400,
                          //   height: 0,
                          // ),
                          style: GoogleFonts.abel(
                              textStyle: const TextStyle(fontSize: 18)),
                        ),
                        Row(children: [
                          const Icon(
                            Icons.location_pin,
                            size: 15,
                          ),
                          Text(
                            "${card.location}",
                            // style: const TextStyle(
                            //   color: Colors.black,
                            //   fontSize: 18,
                            //   fontFamily: 'SevenSegment',
                            //   fontWeight: FontWeight.w400,
                            //   height: 0,
                            // ),

                            style: GoogleFonts.abel(
                                textStyle: const TextStyle(fontSize: 18)),
                          )
                        ]),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right:5),
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    card.price.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 36,
                                      fontFamily: 'SevenSegment',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    card.liters.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontFamily: 'SevenSegment',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "€",
                                    style: GoogleFonts.abel(
                                        textStyle:
                                            const TextStyle(fontSize: 30)),
                                  ),
                                  Text(
                                    "L",
                                    style: GoogleFonts.abel(
                                        textStyle:
                                            const TextStyle(fontSize: 21)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                        padding: const EdgeInsets.only(right:5),
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    card.euroPerLiter.toStringAsFixed(3),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 36,
                                      fontFamily: 'SevenSegment',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "€/L",
                                style: GoogleFonts.abel(
                                    textStyle: const TextStyle(fontSize: 25)),
                              ),
                            )
                          ],
                        )
                      ])

                ],
                // ListTile(
                //   title: Text('Price: ${card.price} €'),
                //   subtitle: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('Liters: ${card.liters} L'),
                //       Text('Date: ${card.date}'),
                //       Text('Location: ${card.location}'),
                //       Text('€/L: ${card.euroPerLiter} €/L'),
                //     ],
              ),
            ),
          ),
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

  Widget _buildBottomSheetContent() {
    return const RefuelForm();
    // return Container(
    //   padding: EdgeInsets.all(16.0),
    //   height: MediaQuery.of(context).size.height * 2 / 3,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       // Price Field
    //       TextFormField(
    //         decoration: InputDecoration(labelText: 'Price'),
    //         keyboardType: TextInputType.number,
    //         onChanged: (value) {
    //           // newCard.price = double.parse(value);
    //         },
    //       ),

    //       // Liters Field
    //       TextFormField(
    //         decoration: InputDecoration(labelText: 'Liters'),
    //         keyboardType: TextInputType.number,
    //         onChanged: (value) {
    //           // newCard.liters = double.parse(value);
    //         },
    //       ),

    //       // Date Field
    //       TextFormField(
    //         decoration: InputDecoration(labelText: 'Date'),
    //         onChanged: (value) {
    //           // newCard.date = value;
    //         },
    //       ),

    //       // Location Field
    //       TextFormField(
    //         decoration: InputDecoration(labelText: 'Location'),
    //         onChanged: (value) {
    //           // newCard.location = value;
    //         },
    //       ),

    //       // EuroPerLiter Field
    //       TextFormField(
    //         decoration: InputDecoration(labelText: 'EuroPerLiter'),
    //         keyboardType: TextInputType.number,
    //         onChanged: (value) {
    //           // newCard.euroPerLiter = double.parse(value);
    //         },
    //       ),

    //       // Save Button
    //       ElevatedButton(
    //         onPressed: () {
    //           CardData newCard = CardData(
    //             id: DateTime.now().millisecondsSinceEpoch,
    //             price: (100).roundToDouble(),
    //             liters: (50).roundToDouble(),
    //             date: DateTime.now().toString(),
    //             location: 'Random Location',
    //             euroPerLiter: (3).roundToDouble(),
    //           );
    //           // Save the new card and close the bottom sheet
    //           _saveNewCard(newCard);
    //         },
    //         child: Text('Save'),
    //       ),

    //       // Cancel Button
    //       TextButton(
    //         onPressed: () {
    //           // Close the bottom sheet
    //           Navigator.of(context).pop();
    //         },
    //         child: Text('Cancel'),
    //       ),
    //     ],
    //   ),
    // );
  }

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

class RefuelForm extends StatefulWidget {
  const RefuelForm({Key? key}) : super(key: key);

  @override
  RefuelFormState createState() {
    return RefuelFormState();
  }
}

class RefuelFormState extends State<RefuelForm> {
  final _formKey = GlobalKey<FormState>();

  // Create text controllers for each field in CardData
  final priceController = TextEditingController();
  final litersController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  final euroPerLiterController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    litersController.dispose();
    dateController.dispose();
    locationController.dispose();
    euroPerLiterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Price and Liters
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: TextFormField(
                      controller: litersController,
                      decoration: const InputDecoration(
                        labelText: 'Liters',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter liters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Date and Time Picker
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      DateTime pickedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      dateController.text = pickedDateTime
                          .toString(); // Store the formatted date in the text controller
                    }
                  }
                },
              ),
            ),

            // Map for Location
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  // Show a modal bottom sheet or navigate to a map page to select the location
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      // Replace this with your actual map selection widget
                      return Container(
                        height: 200,
                        child: const Center(
                          child: Text('Map Placeholder'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, create a new CardData object
                    CardData newCard = CardData(
                      id: DateTime.now().millisecondsSinceEpoch,
                      price: double.parse(priceController.text),
                      liters: double.parse(litersController.text),
                      date: dateController.text,
                      location: locationController.text,
                      euroPerLiter: double.parse(priceController.text) /
                          double.parse(litersController.text),
                    );

                    // saveNewCard(CardData)

                    // Display entered values in an AlertDialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            children: [
                              Text('Price: ${newCard.price}'),
                              Text('Liters: ${newCard.liters}'),
                              Text('Date: ${newCard.date}'),
                              Text('Location: ${newCard.location}'),
                              Text('EuroPerLiter: ${newCard.euroPerLiter}'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
