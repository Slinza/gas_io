import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/screens/home_screen.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/fuel_type.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void nextAction(int currentPage) {
    if (currentPage < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              const WelcomePage(),
              NameSurnamePage(),
              CarDataPage(),
            ],
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: const Text('Back'),
                      )
                    : Container(
                        width: 80,
                      ),
                Text('Page ${_currentPage + 1} of 3'),
                ElevatedButton(
                  onPressed: () {
                    nextAction(_currentPage);
                  },
                  child: _currentPage + 1 == 3
                      ? const Text("Start")
                      : const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: const Center(
        child: Text(
          'Welcome to GasIO!',
          style: onbordingTitleStyle,
        ),
      ),
    );
  }
}

class NameSurnamePage extends StatelessWidget {
  NameSurnamePage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> saveUserData() async {
    UserData user = UserData(
        id: 0,
        name: _nameController.text,
        surname: _surnameController.text,
        username: _usernameController.text,
        email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'How should we call you?',
                style: onbordingTitleStyle,
              ),
              const SizedBox(
                height: 100,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarDataPage extends StatefulWidget {
  CarDataPage({super.key});

  @override
  State<CarDataPage> createState() => _CarDataPageState();
}

class _CarDataPageState extends State<CarDataPage> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _initialKmController = TextEditingController();

  FuelType _selectedFuelType = FuelType.diesel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(30),
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
                    //suffixText: "Year",
                    border: UnderlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
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
                // ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.saveAndValidate()) {
                //       saveCarData();
                //     }
                //   },
                //   child: const Text('Add'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
