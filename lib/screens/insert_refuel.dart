import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gas_io/screens/insert_refuel.dart';
// import 'package:gas_io/screens/refuel_insert_form.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/refuel_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class InsertRefuel extends StatefulWidget {
  const InsertRefuel({Key? key}) : super(key: key);

  @override
  _InsertRefuelState createState() => _InsertRefuelState();
}

class _InsertRefuelState extends State<InsertRefuel> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _euroPerLiterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Refuel'),
      ),
      body:

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
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(

                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true,),
                  onSaved: (value) {

                  },
                ),
                TextFormField(
                  controller: _litersController,
                  decoration: InputDecoration(labelText: 'Liters'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                // TextFormField(
                //   readOnly: true,
                //   controller: _dateController,
                //   decoration: InputDecoration(labelText: 'Date'),
                // ),
                // TextFormField(
                //   readOnly: true,
                //   controller: _locationController,
                //   decoration: InputDecoration(labelText: 'Location'),
                // ),
                // TextFormField(
                //   readOnly: true,
                //   controller: _euroPerLiterController,
                //   decoration: InputDecoration(labelText: 'EuroPerLiter'),
                // ),
                SizedBox(height: 16.0), // Spacer for some vertical separation
                ElevatedButton(
                  onPressed: () {
                    // if(_formKey.currentState!.validate()){
                      _saveDataAndClose(context);
                    // }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveDataAndClose(BuildContext context) async{
    // Extract data from controllers
    double price = double.tryParse(_priceController.text) ?? 0.1;
    double liters = double.tryParse(_litersController.text) ?? 0.1;
    // String date = _dateController.text;
    // String location = _locationController.text;
    // double euroPerLiter = double.tryParse(_euroPerLiterController.text) ?? 0.0;

    // TODO: Save data to the database or perform other necessary actions

    final random = Random();
    // double euroPerLiter = 1.568 + random.nextDouble() * (2.134 - 1.568);
    // double liters = 10 + random.nextDouble() * (60 - 10);
    CardData newCard = CardData(
      id: DateTime.now().millisecondsSinceEpoch,
      price: price,
      liters: liters,
      date: DateTime.now(),
      location: 'Random Location',
      euroPerLiter: price/liters,
    );



    await _databaseHelper.insertCard(newCard);

    // Navigator.pop with the result (you can pass some data as a result)
    Navigator.of(context).pop(newCard);
  }
}
