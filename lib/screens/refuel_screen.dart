import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_io/screens/insert_refuel.dart';
// import 'package:gas_io/screens/refuel_insert_form.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../components/app_bar.dart';



class RefuelScreen extends StatefulWidget {
  int selectedCarId;
  RefuelScreen({Key? key, required this.selectedCarId}) : super(key: key);

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

  @override
  void didUpdateWidget(covariant RefuelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCarId != oldWidget.selectedCarId) {
      _loadCards();
    }
  }

  Future<void> _loadCards() async {
    List<CardData> cards = await _databaseHelper.getCardsByCar(widget.selectedCarId);
    setState(() {
      _cardList = cards;
    });
    // Scroll to the top when a new card is added
    _listController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _addNewCard() async {
    // Navigate to the insert page and wait for the result

    final newCard = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertRefuel(widget.selectedCarId)),
    );

    // Check if the result is not null and reload the cards
    if (newCard != null) {
      _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        child: const Icon(Icons.add),
      ),
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
                    foregroundColor: Colors.orange,
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
}