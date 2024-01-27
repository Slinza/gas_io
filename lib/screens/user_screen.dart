import 'package:flutter/material.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/user_schema.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isEditable = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  UserData userData = UserData(id: 0, name: "", surname: "", username: "");
  String userName = "sdfase";
  String carBrand = 'Brand';
  String carModel = 'Model';
  String profilePic =
      'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void toggleEditable() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  Future<void> _loadUserData() async {
    userData = await _databaseHelper.getUserData(0);
    userName = userData.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isEditable ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: toggleEditable,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(profilePic),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1.0,
                            blurRadius: 2.0,
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isEditable ? Icons.save : Icons.edit,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        onPressed: toggleEditable,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Text(
            //   'Name',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 8.0),
            TextField(
              enabled: isEditable,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: userName,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
            ),

            const SizedBox(height: 24.0),
            const Text(
              'Selected Car',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                hintText: carBrand,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  carModel = value;
                });
              },
            ),
            const SizedBox(height: 8.0),
            TextField(
              enabled: isEditable,
              decoration: InputDecoration(
                hintText: carModel,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  carModel = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
