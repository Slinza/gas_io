import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
  Map<String, dynamic> carDetails = {};

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

  Future<void> saveCarData() async {
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
        title: const Text('New Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormBuilderTextField(
              controller: _brandController,
              name: 'brand',
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
              onSaved: (_) => _brandController.text,
            ),
            const SizedBox(height: 16.0),
            FormBuilderTextField(
              controller: _modelController,
              name: 'model',
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
              onSaved: (_) => _modelController.text,
            ),
            const SizedBox(height: 16.0),
            FormBuilderTextField(
              controller: _yearController,
              name: 'year',
              decoration: const InputDecoration(
                labelText: 'Construction Year',
                //suffixText: "Year",
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  // TODO: add construction year limitation
                  FormBuilderValidators.min(1900),
                ],
              ),
              onSaved: (_) => _yearController.text,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
            ),
            const SizedBox(height: 16.0),
            FormBuilderTextField(
              controller: _initialKmController,
              name: 'km',
              decoration: const InputDecoration(
                labelText: 'Total KM',
                suffixText: "Km",
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                ],
              ),
              onSaved: (_) => _initialKmController.text =
                  _initialKmController.text.replaceAll(',', '.'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveCarData();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
