import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/screens/user_screen.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/fuel_type.dart';

class CarDataPage extends StatefulWidget {
  const CarDataPage({super.key});

  @override
  State<CarDataPage> createState() => _CarDataPageState();
}

class _CarDataPageState extends State<CarDataPage> {
  final _formKeyInit = GlobalKey<FormBuilderState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _initialKmController = TextEditingController();
  FuelType _selectedFuelType = FuelType.diesel;

  Map<String, dynamic> carDetails = {};

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<CarCard> car = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> saveCarData() async {
    CarData? car = CarData(
      id: DateTime.now().toUtc().millisecondsSinceEpoch,
      userId: USER_ID,
      brand: _brandController.text,
      model: _modelController.text,
      year: int.parse(_yearController.text),
      initialKm: double.parse(_initialKmController.text),
      fuelType: fuelTypeToString(_selectedFuelType),
    );

    await _databaseHelper.insertCar(car);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: FormBuilder(
              key: _formKeyInit,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Car to refuel?',
                    style: onbordingTitleStyle,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  FormBuilderTextField(
                    controller: _brandController,
                    name: 'brand',
                    decoration: const InputDecoration(
                      labelText: 'Brand',
                      border: UnderlineInputBorder(),
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
                      border: UnderlineInputBorder(),
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
                      border: UnderlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.integer(),
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
                      labelText: 'Initial Km',
                      suffixText: "Km",
                      border: UnderlineInputBorder(),
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
                  DropdownButton<FuelType>(
                    value: _selectedFuelType,
                    onChanged: (value) {
                      setState(
                        () {
                          if (value != null) {
                            _selectedFuelType = value;
                          }
                        },
                      );
                    },
                    items: FuelType.values.map((FuelType fuelType) {
                      return DropdownMenuItem<FuelType>(
                        value: fuelType,
                        child: Text(fuelType.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKeyInit.currentState!.saveAndValidate()) {
                        saveCarData();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
