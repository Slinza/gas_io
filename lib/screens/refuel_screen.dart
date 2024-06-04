import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gas_io/screens/insert_refuel.dart';
import 'package:gas_io/screens/modify_refuel.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';

class RefuelScreen extends StatefulWidget {
  int selectedCarId;
  RefuelScreen({Key? key, required this.selectedCarId}) : super(key: key);

  @override
  _RefuelScreenState createState() => _RefuelScreenState();
}

class _RefuelScreenState extends State<RefuelScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<RefuelData> _cardList = [];
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
    List<RefuelData> cards =
        await _databaseHelper.getRefuelsByCar(widget.selectedCarId);
    if (mounted) {
      setState(() {
        _cardList = cards;
      });
      _listController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    // Scroll to the top when a new card is added
  }

  Future<void> _modifyCard(cardData) async {
    // Navigate to the insert page and wait for the result
    final updatedCard = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ModifyRefuel(widget.selectedCarId, cardData)),
    );

    // Check if the result is not null and reload the cards
    if (updatedCard != null) {
      _loadCards();
    }
  }

  Future<void> _addNewCard() async {
    // Navigate to the insert page and wait for the result

    final newCard = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InsertRefuel(widget.selectedCarId)),
    );

    // Check if the result is not null and reload the cards
    if (newCard != null) {
      _loadCards();
    }
  }

  Future<void> _showDeleteConfirmation(RefuelData cardData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this card?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _databaseHelper.deleteRefuels(cardData);
                setState(() {
                  _cardList.remove(cardData);
                });
                Navigator.of(context).pop(); // close dialog
              },
            ),
          ],
        );
      },
    );
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
        final RefuelData cardData = _cardList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(
            key: Key(cardData.id.toString()),
            endActionPane: ActionPane(
              extentRatio: 0.5,
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _modifyCard(cardData),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.orange,
                  icon: Icons.edit,
                  label: 'Edit',
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await _showDeleteConfirmation(cardData);
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ],
            ),
            child: RefuelCard(refuelData: cardData),
          ),
        );
      },
    );
  }
}
