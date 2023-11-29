// NOT WORKING PROPERLY FOR NOW

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

  // Variables for undo functionality
  bool _isUndoVisible = false;
  CardData? _removedCard;
  int? _removedIndex;
  bool _isSnackbarVisible = false;

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

  void _removeRandomCard() async {
    if (_cardList.isNotEmpty) {
      int randomIndex = Random().nextInt(_cardList.length);
      _removedCard = _cardList.removeAt(randomIndex);
      _removedIndex = randomIndex;

      await _databaseHelper.deleteCard(_removedCard!);

      setState(() {
        _isUndoVisible = true;
        _isSnackbarVisible = true;
      });

      // Hide the previous Snackbar before showing the new one
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      // Show the SnackBar with an Undo action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Card dismissed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Check if the widget is still mounted before accessing its context
              if (mounted) {
                // Check if the card is still in the list before restoring
                if (!_cardList.contains(_removedCard)) {
                  // Insert the removed card back to its original position
                  _cardList.insert(_removedIndex!, _removedCard!);
                  _databaseHelper.insertCard(_removedCard!);
                }

                setState(() {
                  _isUndoVisible = false;
                  _isSnackbarVisible = false;
                });
              }
            },
          ),
        ),
      );

      // Set a timer for how long the undo action is visible
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          if (_isSnackbarVisible) {
            _isSnackbarVisible = false;
            _isUndoVisible = false;
          }
        });
      });
    }
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
            // Set _removedCard and _removedIndex for undo functionality
            _removedCard = card;
            _removedIndex = index;

            await _databaseHelper.deleteCard(card);

            setState(() {
              _cardList.removeAt(index);
              _isUndoVisible = true;
              _isSnackbarVisible = true;
            });

            // Hide the previous Snackbar before showing the new one
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            // Show the SnackBar with an Undo action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Card dismissed'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Check if the widget is still mounted before accessing its context
                    if (mounted) {
                      // Check if the card is still in the list before restoring
                      if (!_cardList.contains(_removedCard)) {
                        // Insert the removed card back to its original position
                        _cardList.insert(_removedIndex!, _removedCard!);
                        _databaseHelper.insertCard(_removedCard!);
                      }

                      setState(() {
                        _isUndoVisible = false;
                        _isSnackbarVisible = false;
                      });
                    }
                  },
                ),
              ),
            );

            // Set a timer for how long the undo action is visible
            Future.delayed(Duration(seconds: 5), () {
              setState(() {
                if (_isSnackbarVisible) {
                  _isSnackbarVisible = false;
                  _isUndoVisible = false;
                }
              });
            });
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
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Price: ${card.price} €'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Liters: ${card.liters} L'),
                  Text('Date: ${card.date}'),
                  Text('Location: ${card.location}'),
                  Text('€/L: ${card.euroPerLiter} €/L'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up resources and dismiss the card when the screen is disposed.
    if (_isSnackbarVisible) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
    super.dispose();
  }
}
