import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';

class InsertRefuel extends StatefulWidget {
  int selectedCarId;
  InsertRefuel( this.selectedCarId, {Key? key}) : super(key: key);

  @override
  _InsertRefuelState createState() => _InsertRefuelState();
}

class _InsertRefuelState extends State<InsertRefuel> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _euroPerLiterController = TextEditingController();

  DateTime selectedDateTime = DateTime.now();

  late int selectedCarId = widget.selectedCarId;
  Map<int, String> cars = {};
  late Map<String, dynamic> carDetails;


  @override
  void initState() {
    super.initState();
    _loadCars();
    _loadCarDetails();
    // Format the initial datetime and set it to the controller
    _dateController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
  }

  Future<void> _loadCarDetails() async {
    final Map<String, dynamic> carDet = await _databaseHelper.getCarDetailsById(selectedCarId);
    setState(() {
      carDetails=carDet;
    });
    print(carDetails);
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
        title: const Text('Insert Refuel'),
      ),
      body:
          // TODO: substitute Form with FormBuilder
          // FormBuilder(
          //   key: _formKey,
          //   child: Column(
          //     children: [
          //       FormBuilderTextField(
          //         name: 'email',
          //         decoration: const InputDecoration(labelText: 'Email'),
          //         validator: FormBuilderValidators.compose([
          //           FormBuilderValidators.required(),
          //           FormBuilderValidators.email(),
          //         ]),
          //       ),
          //       const SizedBox(height: 10),
          //       FormBuilderTextField(
          //         name: 'password',
          //         decoration: const InputDecoration(labelText: 'Password'),
          //         obscureText: true,
          //         validator: FormBuilderValidators.compose([
          //           FormBuilderValidators.required(),
          //         ]),
          //       ),
          //       MaterialButton(
          //         color: Theme.of(context).colorScheme.secondary,
          //         onPressed: () {
          //           // Validate and save the form values
          //           _formKey.currentState?.saveAndValidate();
          //           debugPrint(_formKey.currentState?.value.toString());
          //
          //           // On another side, can access all field values without saving form with instantValues
          //           _formKey.currentState?.validate();
          //           debugPrint(_formKey.currentState?.instantValue.toString());
          //         },
          //         child: const Text('Login'),
          //       )
          //     ],
          //   ),
          // ),

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedCarId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCarId = newValue ?? 0;
                      _loadCarDetails();

                      // selectedCarName = cars[selectedCarId] ?? '';
                    });
                  },
                  items: cars.keys
                      .toList()
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(cars[value] ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Car'),
                ),
                GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: 'Date and Time'),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _kmController,
                  decoration: const InputDecoration(labelText: 'Km'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: _litersController,
                  decoration: const InputDecoration(labelText: 'Liters'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _updatePrice(),
                ),
                // TextFormField(
                //   readOnly: true,
                //   controller: _locationController,
                //   decoration: InputDecoration(labelText: 'Location'),
                // ),
                TextFormField(
                  controller: _euroPerLiterController,
                  decoration: const InputDecoration(labelText: 'Price (€/L)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _updatePrice(),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Cost (€)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  enabled: false, // Disable user input
                  onSaved: (value) {},
                ),
                const SizedBox(height: 16.0), // Spacer for some vertical separation
                ElevatedButton(
                  onPressed: () {
                    // if(_formKey.currentState!.validate()){
                    _saveDataAndClose(context);
                    // }
                  },
                  child: const Text('Save'),
                ),
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
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
    double liters =
        double.tryParse(_litersController.text.replaceAll(',', '.')) ?? 0.0;
    double euroPerLiter =
        double.tryParse(_euroPerLiterController.text.replaceAll(',', '.')) ??
            0.0;
    double km = double.tryParse(_kmController.text.replaceAll(',', '.')) ?? 0.0;

    CardData newCard = CardData(
        id: DateTime.now().millisecondsSinceEpoch,
        carId: selectedCarId,
        price: price,
        liters: liters,
        date: selectedDateTime,
        location: 'Random Location',
        euroPerLiter: euroPerLiter,
        km: km);
    // TODO: handle km update also on the car
    await _databaseHelper.insertCard(newCard);

    // Navigator.pop with the result (you can pass some data as a result)
    Navigator.of(context).pop(newCard);
  }

  void _updatePrice() {
    // Update the price based on Liters and €/L values
    double liters =
        double.tryParse(_litersController.text.replaceAll(',', '.')) ?? 0.0;
    double euroPerLiter =
        double.tryParse(_euroPerLiterController.text.replaceAll(',', '.')) ??
            0.0;

    double price = liters * euroPerLiter;

    // Update the price field
    setState(() {
      _priceController.text = price.toStringAsFixed(2); // Format as needed
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Format and update the date controller
          _dateController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
        });
      }
    }
  }
}
