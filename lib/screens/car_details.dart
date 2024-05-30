import 'package:flutter/material.dart';

import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/design/styles.dart';

class DetailsCarInsertionScreen extends StatefulWidget {
  CarData carData;
  DetailsCarInsertionScreen(this.carData, {Key? key}) : super(key: key);

  @override
  _DetailsCarInsertionScreenState createState() =>
      _DetailsCarInsertionScreenState();
}

class _DetailsCarInsertionScreenState extends State<DetailsCarInsertionScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
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
