import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
  // final TextEditingController _locationController = TextEditingController();
  final TextEditingController _pricePerLiterController =
      TextEditingController();

  late int selectedCarId;
  Map<int, String> cars = {};
  Map<String, dynamic> carDetails = {};
  double previousRefuelKm = -1;
  double nextRefuelKm = -1;

  @override
  void initState() {
    selectedCarId = widget.selectedCarId;
    _loadCars();
    _loadCarDetails();
    _loadPreviousAndNextRefuel(widget.cardData.date, widget.cardData.id);
    _loadRefuelData(widget.cardData);
    super.initState();
  }

  // final String relatedCarIdKey = 'carId';

  void _loadRefuelData(cardData) {
    setState(() {
      _pricePerLiterController.text = cardData.euroPerLiter.toString();
      _litersController.text = cardData.liters.toString();
      _costController.text = cardData.price.toString();
      _kmController.text= cardData.km.toString();

      // _costController.text = price.toStringAsFixed(2); // Format as needed
    });
  }

  Future<void> _loadPreviousAndNextRefuel(selectedDateTime, refuelId) async {
    Map<String, CardData?> refuels = await _databaseHelper
        .getPreviousAndNextRefuel(selectedCarId, selectedDateTime, excludeRefuelId: refuelId);

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
      // if (carMap.isNotEmpty) {
      //   selectedCarId = carMap.keys.toList()[0];
      //   // selectedCarName = carMap[selectedCarId] ?? ''; // Set the first car as default
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.directions_car), // Add car icon
            const SizedBox(width: 8.0),
            Text(
              cars[selectedCarId] ?? '',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.orange, // Change the text color
              ),
            ),
            // Text(
            //   ' refuel', // Screen name suggestion
            //   style: TextStyle(
            //     fontSize: 18.0,
            //   ),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        onChanged: (value) => _loadPreviousAndNextRefuel(value, widget.cardData.id)
                        ,
                        // controller: _dateController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        name: 'date',
                        // firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.calendar,
                        initialValue: widget.cardData.date,
                        format: DateFormat(
                            "dd/MM/yyyy  HH:mm"), //DateFormat('HH:mm, dd MMMM yyyy'),
                        inputType: InputType.both,
                        decoration: const InputDecoration(
                          labelText: 'Refuel Time',
                          alignLabelWithHint: true, // Align label with the hint

                          border: OutlineInputBorder(),
                          // suffixIcon: IconButton(
                          //   icon: const Icon(Icons.close),
                          //   onPressed: () {
                          //     _formKey.currentState!.fields['date']?.didChange(null);
                          //   },
                          // ),
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
                          // the km inserted must be higher than the previous refuel and lower than a possible next refuel
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
                    const SizedBox(
                      width: 5,
                    ),
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
                const SizedBox(
                    height: 16.0), // Spacer for some vertical separation
                MaterialButton(
                  color: Colors.orange,
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      // debugPrint(_formKey.currentState?.value.toString());
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
    // Extract data from controllers
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
        location: 'Random Location',
        euroPerLiter: euroPerLiter,
        km: km);
    await _databaseHelper.updateCard(newCard);
    // Navigator.pop with the result (you can pass some data as a result)
    Navigator.of(context).pop(newCard);
  }

  void _updatePrice() {
    // Update the price based on Liters and €/L values
    double liters =
        double.tryParse(_litersController.text.replaceAll(',', '.')) ?? 0.0;
    double euroPerLiter =
        double.tryParse(_pricePerLiterController.text.replaceAll(',', '.')) ??
            0.0;
    double price = liters * euroPerLiter;
    // Update the price field
    setState(() {
      _costController.text = price.toStringAsFixed(2); // Format as needed
    });
  }
}
