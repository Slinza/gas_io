import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:gas_io/screens/user_screen.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/fuel_type.dart';
import 'package:gas_io/design/styles.dart';

class DetailsCarSettingsScreen extends StatefulWidget {
  CarData carData;
  DetailsCarSettingsScreen(this.carData, {Key? key}) : super(key: key);

  @override
  _DetailsCarSettingsScreenState createState() =>
      _DetailsCarSettingsScreenState();
}

class _DetailsCarSettingsScreenState extends State<DetailsCarSettingsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  CarData carDetails = defaultCarData;

  @override
  void initState() {
    _loadCarData(widget.carData);
    super.initState();
  }

  void _loadCarData(cardData) {
    setState(() {
      carDetails = cardData;
    });
  }

  void _removeCarData(carData) async {
    await _databaseHelper.deleteCar(carData);
    Navigator.pop(context, true);
  }

  void _closeDetailsScreen() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.delete_forever),
        //     onPressed: () {
        //       _removeCarData(widget.carData);
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CarDetais(label: "Brand", value: carDetails.brand),
            CarDetais(
              label: "Model",
              value: carDetails.model,
            ),
            CarDetais(
              label: "Fuel",
              value: carDetails.fuelType,
            ),
            CarDetais(
              label: "Year",
              value: carDetails.year.toString(),
            ),
            CarDetais(
              label: "Initial Km",
              value: carDetails.initialKm.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class CarDetais extends StatelessWidget {
  final String label;
  final String value;
  const CarDetais({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            label,
            style: detailsStyleBold,
          ),
          const SizedBox(width: 16.0),
          Text(
            value,
            style: detailsStyle,
          )
        ],
      ),
    );
  }
}
