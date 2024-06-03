import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:gas_io/design/styles.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/screens/user_settings.dart';
import 'package:gas_io/screens/car_insertion.dart';
import 'package:gas_io/components/car_card.dart';

const USER_ID = 0; //TODO: Make it changiable

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ScrollController _listController = ScrollController();
  UserData? _user;
  List<CarData> _cardList = [];

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    _user = await _databaseHelper.getUser();
    List<CarData> cardList = await _databaseHelper.getCarsByUser(USER_ID);

    setState(
      () {
        _cardList = cardList;
      },
    );

    // Scroll to the top when a new card is added
    if (_listController.hasClients) {
      _listController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _addNewCard() async {
    // Navigate to the insert page and wait for the result
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CarInsertionScreen()),
    ).then((value) {
      if (value != null && value) {
        fetchUserData();
      }
    });
  }

  Future<void> _userSettings() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserSettingsScreen()),
    ).then((value) {
      if (value != null && value) {
        fetchUserData();
      }
    });
  }

  Future<void> _showDeleteConfirmation(CarData cardData) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        if (_cardList.length > 1) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Do you want to delete this car and all the relative refuel?'),
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
                  await _databaseHelper.deleteCar(cardData);
                  setState(() {
                    _cardList.remove(cardData);
                  });
                  Navigator.of(context).pop(); // close dialog
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Operation Denied!'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'There must be at least one car! Create a new one before deleting this one'),
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
            ],
          );
        }
      },
    );
  }

  Widget _buildCardList() {
    return ListView.builder(
      controller: _listController,
      itemCount: _cardList.length,
      itemBuilder: (context, index) {
        final CarData carData = _cardList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(
            key: Key(carData.id.toString()),
            endActionPane: ActionPane(
              extentRatio: 0.5,
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await _showDeleteConfirmation(carData);
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ],
            ),
            child: CarCard(carData: carData),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () {
              _addNewCard();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _userSettings();
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40.0),
                    Text(
                      _user!.username,
                      textAlign: TextAlign.center,
                      style: detailsStyle,
                    ),
                    const SizedBox(height: 60.0),
                    SizedBox(
                      width: 200,
                      height: 600,
                      child: _buildCardList(),
                    )
                  ],
                )
              : null),
    );
  }
}
