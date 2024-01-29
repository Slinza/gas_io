import 'package:flutter/material.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/screens/user_settings.dart';

const USER_ID = 0; //TODO: Make it changiable

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserData? _user;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String profilePic = 'assets/user_icon.png';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    //DatabaseHelper helper = DatabaseHelper.instance;
    _user = await _databaseHelper.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
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
                  ],
                )
              : null),
    );
  }
}
