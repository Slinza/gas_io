import 'package:flutter/material.dart';
import 'package:gas_io/components/app_bar.dart';
import 'package:gas_io/components/bottom_nav_bar.dart';
import 'package:gas_io/screens/stats_screen.dart';
import 'package:gas_io/screens/refuel_screen.dart';
import 'package:gas_io/screens/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
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
