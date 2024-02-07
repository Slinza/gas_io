import 'package:flutter/material.dart';
import 'package:gas_io/screens/user_screen.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/car_card.dart';

class CarSettingsScreen extends StatefulWidget {
  @override
  _CarSettingsScreenState createState() => _CarSettingsScreenState();
}

class _CarSettingsScreenState extends State<CarSettingsScreen> {
  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _initialKmController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<CarCard> car = [];
  // final int selectedCarId;
  // final Map<int, String> cars;
  // final Function(int) onCarChanged;

  // const MyAppBar({
  //   Key? key,
  //   required this.selectedCarId,
  //   required this.cars,
  //   required this.onCarChanged,
  // }) : super(key: key);

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveUserData() async {
    CarData? car = CarData(
        id: 0,
        userId: USER_ID,
        brand: "Brand",
        model: "Model",
        year: 2024,
        initialKm: 0);

    car.brand = _brandController.text;
    car.model = _modelController.text;
    // car.year = _yearController.text;
    // car.initialKm = _initialKmController.text;
    await _databaseHelper.insertCar(car);
    Navigator.pop(context, true);
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
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
              ),
            ),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
              ),
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Construction Year',
              ),
            ),
            TextField(
              controller: _initialKmController,
              decoration: const InputDecoration(
                labelText: 'Initial Km',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                saveUserData();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
