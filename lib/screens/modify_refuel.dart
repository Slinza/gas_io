import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gas_io/components/gas_station_schema.dart';

class ModifyRefuel extends StatefulWidget {
  int selectedCarId;
  CardData cardData;
  ModifyRefuel(this.selectedCarId, this.cardData, {Key? key}) : super(key: key);

  @override
  _ModifyRefuelState createState() => _ModifyRefuelState();
}

class _ModifyRefuelState extends State<ModifyRefuel> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _pricePerLiterController =
      TextEditingController();

  late int selectedCarId;
  Map<int, String> cars = {};
  Map<String, dynamic> carDetails = {};
  double previousRefuelKm = -1;
  double nextRefuelKm = -1;
  bool isCompleteRefuel = false; // New variable to track refuel completeness
  GasStationData? nearestGasStation;

  @override
  void initState() {
    selectedCarId = widget.selectedCarId;
    _loadCars();
    _loadCarDetails();
    _loadPreviousAndNextRefuel(widget.cardData.date, widget.cardData.id);
    _loadRefuelData(widget.cardData);
    _loadGasStation(widget.cardData.gasStationId);
    super.initState();
  }

  Future<void> _loadGasStation(gasStationId) async {
    final GasStationData? refuelGasStation =
        await _databaseHelper.getGasStationById(gasStationId);
    setState(() {
      nearestGasStation = refuelGasStation;
    });
  }

  Widget _buildNearestGasStationCard() {
    if (nearestGasStation != null) {
      return Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gas station logo
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.local_gas_station,
                  size: 45,
                  color: Colors.orange, // Adjust color as needed
                ),
              ),
              // Gas station details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nearestGasStation!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(nearestGasStation!.shortFormattedAddress),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Return a loading card widget if nearestGasStation is null
      return const Card(
        elevation: 4.0,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height:
                      20, // Adjust the size of the CircularProgressIndicator
                  width: 20, // Adjust the size of the CircularProgressIndicator
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 10),
                Text(
                  'Searching for the nearest Gas Station',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _loadRefuelData(cardData) {
    setState(() {
      _pricePerLiterController.text = cardData.euroPerLiter.toString();
      _litersController.text = cardData.liters.toString();
      _costController.text = cardData.price.toString();
      _kmController.text = cardData.km.toString();
      isCompleteRefuel =
          cardData.isCompleteRefuel; // Load the completeness value
    });
  }

  Future<void> _loadPreviousAndNextRefuel(selectedDateTime, refuelId) async {
    Map<String, CardData?> refuels = await _databaseHelper
        .getPreviousAndNextRefuel(selectedCarId, selectedDateTime,
            excludeRefuelId: refuelId);

    CardData? previousRefuel = refuels['previousRefuel'];
    CardData? nextRefuel = refuels['nextRefuel'];
    setState(() {
      if (previousRefuel != null) {
        previousRefuelKm = previousRefuel.km;
      }

      if (nextRefuel != null) {
        nextRefuelKm = nextRefuel.km;
      }
    });
  }

  Future<void> _loadCarDetails() async {
    final Map<String, dynamic> carDet =
        await _databaseHelper.getCarDetailsById(selectedCarId);
    setState(() {
      carDetails = carDet;
    });
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
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.directions_car),
            const SizedBox(width: 8.0),
            Text(
              cars[selectedCarId] ?? '',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                // Display the nearest gas station card above the form
                const SizedBox(height: 16.0),
                _buildNearestGasStationCard(),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        onChanged: (value) => _loadPreviousAndNextRefuel(
                            value, widget.cardData.id),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        name: 'date',
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.calendar,
                        initialValue: widget.cardData.date,
                        format: DateFormat("dd/MM/yyyy  HH:mm"),
                        inputType: InputType.both,
                        decoration: const InputDecoration(
                          labelText: 'Refuel Time',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: FormBuilderTextField(
                        controller: _kmController,
                        name: 'km',
                        decoration: const InputDecoration(
                          labelText: 'Total KM',
                          suffixText: "Km",
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          if (carDetails.isNotEmpty)
                            FormBuilderValidators.min(carDetails["initialKm"],
                                inclusive: false,
                                errorText: "Lower than initial car km"),
                          if (carDetails.isNotEmpty &&
                              previousRefuelKm > carDetails["initialKm"])
                            FormBuilderValidators.min(previousRefuelKm,
                                inclusive: false,
                                errorText: "Lower than previous refuel"),
                          if (carDetails.isNotEmpty &&
                              nextRefuelKm > previousRefuelKm)
                            FormBuilderValidators.max(nextRefuelKm,
                                inclusive: false,
                                errorText: "Higher than next refuel"),
                        ]),
                        onSaved: (_) => _kmController.text =
                            _kmController.text.replaceAll(',', '.'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        controller: _litersController,
                        name: 'liters',
                        decoration: const InputDecoration(
                          labelText: 'Liters',
                          suffixText: "L",
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric()
                        ]),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onSaved: (_) => _litersController.text =
                            _litersController.text.replaceAll(',', '.'),
                        onChanged: (_) => _updatePrice(),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: FormBuilderTextField(
                        controller: _pricePerLiterController,
                        name: 'pricePerLiter',
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          suffixText: "€/L",
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric()
                        ]),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onSaved: (_) => _pricePerLiterController.text =
                            _pricePerLiterController.text.replaceAll(',', '.'),
                        onChanged: (_) => _updatePrice(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                FormBuilderTextField(
                  controller: _costController,
                  name: 'cost',
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                    border: OutlineInputBorder(),
                    suffixText: "€",
                  ),
                  enabled: false,
                  readOnly: true,
                ),
                const SizedBox(height: 16.0),
                FormBuilderCheckbox(
                  name: 'isCompleteRefuel',
                  title: const Text('Complete Refuel'),
                  onChanged: (value) {
                    setState(() {
                      isCompleteRefuel = value ?? false;
                    });
                  },
                  initialValue: isCompleteRefuel,
                ),
                const SizedBox(height: 16.0),
                MaterialButton(
                  color: Colors.orange,
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      _saveDataAndClose(context);
                    }
                  },
                  child: const Text('UPDATE REFUEL'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveDataAndClose(BuildContext context) async {
    double price =
        double.tryParse(_costController.text.replaceAll(',', '.')) ?? 0.0;
    double liters =
        double.tryParse(_litersController.text.replaceAll(',', '.')) ?? 0.0;
    double euroPerLiter =
        double.tryParse(_pricePerLiterController.text.replaceAll(',', '.')) ??
            0.0;
    double km = double.tryParse(_kmController.text.replaceAll(',', '.')) ?? 0.0;

    CardData newCard = CardData(
      id: widget.cardData.id,
      carId: selectedCarId,
      price: price,
      liters: liters,
      date: _formKey.currentState!.value["date"],
      gasStationId: nearestGasStation!.id,
      euroPerLiter: euroPerLiter,
      km: km,
      isCompleteRefuel: isCompleteRefuel, // Assign the selected value
    );
    await _databaseHelper.updateCard(newCard);
    Navigator.of(context).pop(newCard);
  }

  void _updatePrice() {
    double liters =
        double.tryParse(_litersController.text.replaceAll(',', '.')) ?? 0.0;
    double euroPerLiter =
        double.tryParse(_pricePerLiterController.text.replaceAll(',', '.')) ??
            0.0;
    double price = liters * euroPerLiter;
    setState(() {
      _costController.text = price.toStringAsFixed(2);
    });
  }
}
