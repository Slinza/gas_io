import 'package:flutter/material.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/screens/user_settings.dart';
import 'package:gas_io/screens/car_settings.dart';
import 'package:gas_io/screens/car_settings_modification.dart';
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
    _cardList = await _databaseHelper.getCarsByUser(USER_ID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CarSettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserSettingsScreen()),
              ).then((value) {
                if (value != null && value) {
                  fetchUserData();
                }
              });
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
                      child: ListView.builder(
                        controller: _listController,
                        itemCount: _cardList.length,
                        itemBuilder: (context, index) {
                          final CarData carData = _cardList[index];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CarCard(carData: carData));
                        },
                      ),
                    )
                  ],
                )
              : null),
    );
  }
}
