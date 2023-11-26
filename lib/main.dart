import 'package:flutter/material.dart';
import 'package:gas_io/screens/app_bar.dart';
import 'package:gas_io/screens/bottom_nav_bar.dart';
import 'package:gas_io/screens/stats_screen.dart';
import 'package:gas_io/screens/refuel_screen.dart';
import 'package:gas_io/screens/user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: _buildBody(),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const StatsScreen();
      case 1:
        return const RefuelScreen();
      case 2:
        return const UserScreen();
      default:
        return Container(); // Handle unexpected index
    }
  }
}
