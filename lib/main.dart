import 'package:flutter/material.dart';
import 'package:gas_io/components/app_bar.dart';
import 'package:gas_io/components/bottom_nav_bar.dart';
import 'package:gas_io/screens/stats_screen.dart';
import 'package:gas_io/screens/refuel_screen.dart';
import 'package:gas_io/screens/user_screen.dart';
import 'package:gas_io/utils/database_helper.dart';

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
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int _currentIndex = 1;

  int selectedCarId = 1; // Initialize with a default car ID
  Map<int, String> cars = {};

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final Map<int, String> carMap = await _databaseHelper.getCarsMap();
    setState(() {
      cars = carMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 2
          ? null // Set app bar to null when UserScreen is selected
          : MyAppBar(
              selectedCarId: selectedCarId,
              cars: cars,
              onCarChanged: (int newValue) {
                setState(() {
                  selectedCarId = newValue;
                  _loadCars();
                });
              },
            ),
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
        return StatsScreen(selectedCarId: selectedCarId);
      case 1:
        return RefuelScreen(selectedCarId: selectedCarId);
      case 2:
        return const UserScreen();
      default:
        return Container(); // Handle unexpected index
    }
  }
}
