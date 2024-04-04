import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// import 'package:gas_io/screens/user_screen.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/fuel_type.dart';

// ***** DEPRECATED *****
// ***** DEPRECATED *****
// ***** DEPRECATED *****
// ***** DEPRECATED *****
// ***** DEPRECATED *****
// ***** DEPRECATED *****

class ModifyCarSettingsScreen extends StatefulWidget {
  CarData carData;
  ModifyCarSettingsScreen(this.carData, {Key? key}) : super(key: key);

  @override
  _ModifyCarSettingsScreenState createState() =>
      _ModifyCarSettingsScreenState();
}

class _ModifyCarSettingsScreenState extends State<ModifyCarSettingsScreen> {
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
    _loadCarData(widget.carData);
    super.initState();
  }

  void _loadCarData(cardData) {
    setState(() {
      _brandController.text = cardData.brand.toString();
      _modelController.text = cardData.model.toString();
      _yearController.text = cardData.year.toString();
      _initialKmController.text = cardData.initialKm.toString();
      _selectedFuelType = stringToFuelType(cardData.fuelType.toString());
      // _costController.text = price.toStringAsFixed(2); // Format as needed
    });
  }

  void _removeCarData(carData) async {
    _databaseHelper.deleteCar(carData);
  }

  void _saveCarData() async {
    CarData newCar = CarData(
      id: widget.carData.id,
      userId: widget.carData.userId,
      brand: _brandController.text,
      model: _modelController.text,
      year: int.parse(_yearController.text),
      initialKm: double.parse(_initialKmController.text),
      fuelType: fuelTypeToString(_selectedFuelType),
    );
    await _databaseHelper.updateCar(newCar);
    // Navigator.pop with the result (you can pass some data as a result)
    //Navigator.of(context).pop(newCar);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Car'),
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
                labelText: 'Initial Km',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _removeCarData(widget.carData);
                  },
                  child: const Text('Remove'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveCarData();
                  },
                  child: const Text('Update'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
