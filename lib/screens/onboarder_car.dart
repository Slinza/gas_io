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
  final Function(bool) onCarDataValid;

  const CarDataPage({super.key, required this.onCarDataValid});

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

  bool _isSaving = false;

  Future<void> saveCarData() async {
    setState(() {
      _isSaving = true;
    });

    CarData? car = CarData(
      id: 0,
      userId: USER_ID,
      brand: _brandController.text,
      model: _modelController.text,
      year: int.parse(_yearController.text),
      initialKm: double.parse(_initialKmController.text),
      fuelType: fuelTypeToString(_selectedFuelType),
    );

    await _databaseHelper.insertCar(car);

    setState(() {
      _isSaving = false;
    });

    widget.onCarDataValid(true);
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
                    height: 80,
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
                    enabled: !_isSaving,
                  ),
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
                    enabled: !_isSaving,
                  ),
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
                    enabled: !_isSaving,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  ),
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
                    enabled: !_isSaving,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<FuelType>(
                    value: _selectedFuelType,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          _selectedFuelType = value;
                        }
                      });
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
                    onPressed: _isSaving
                        ? null
                        : () {
                      if (_formKeyInit.currentState!.saveAndValidate()) {
                        saveCarData();
                      } else {
                        widget.onCarDataValid(false);
                      }
                    },
                    child: _isSaving
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : const Text('Add'),
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
