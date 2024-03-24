import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/screens/user_settings.dart';
import 'package:gas_io/screens/car_settings.dart';
import 'package:gas_io/screens/car_settings_details.dart';
import 'package:gas_io/components/car_card.dart';

const USER_ID = 0; //TODO: Make it changiable

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String profilePic = 'assets/user_icon.png';
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
    //DatabaseHelper helper = DatabaseHelper.instance;
    _user = await _databaseHelper.getUser();
    List<CarData> cardList = await _databaseHelper.getCarsByUser(USER_ID);

    setState(() {
      _cardList = cardList;
    });
    // Scroll to the top when a new card is added
    if (_listController.hasClients) {
      _listController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _modifyCard(cardData) async {
    // Navigate to the insert page and wait for the result
    final newCard = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsCarSettingsScreen(cardData)),
    );

    // Check if the result is not null and reload the cards
    if (newCard != null) {
      fetchUserData();
    }
  }

  Future<void> _addNewCard() async {
    // Navigate to the insert page and wait for the result
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CarSettingsScreen()),
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
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext context) {
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
                  onPressed: (context) => _modifyCard(carData),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.orange,
                  icon: Icons.info, //Icons.edit,
                  label: 'Details', //'Edit',
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
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
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage(
                                profilePic), //NetworkImage(profilePic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Name: ${_user!.name}',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 16.0),
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
