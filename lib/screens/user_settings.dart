import 'package:flutter/material.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/user_schema.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    UserData? user = await _databaseHelper.getUser();
    if (user != null) {
      _nameController.text = user.name;
      _surnameController.text = user.surname;
      _usernameController.text = user.username;
    }
  }

  Future<void> saveUserData() async {
    UserData? user = await _databaseHelper.getUser();
    if (user != null) {
      user.name = _nameController.text;
      user.surname = _surnameController.text;
      user.username = _usernameController.text;
      await _databaseHelper.updateUser(user);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: 'Surname',
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                saveUserData();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}