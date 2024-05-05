import 'package:flutter/material.dart';

import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/screens/home_screen.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';

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
              const CarDataPage(),
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

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _surnameController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        children: [
          const Text(
            'How should we call you?',
            style: onbordingTitleStyle,
          ),
          // TextField(
          //   controller: _nameController,
          //   decoration: const InputDecoration(
          //     labelText: 'Name',
          //   ),
          // ),
          // TextField(
          //   controller: _surnameController,
          //   decoration: const InputDecoration(
          //     labelText: 'Surname',
          //   ),
          // ),
          // TextField(
          //   controller: _usernameController,
          //   decoration: const InputDecoration(
          //     labelText: 'Username',
          //   ),
          // ),
          // TextField(
          //   controller: _emailController,
          //   decoration: const InputDecoration(
          //     labelText: 'Email',
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CarDataPage extends StatelessWidget {
  const CarDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: const Center(
        child: Text(
          'Which car do we want to refuel?',
          style: onbordingTitleStyle,
        ),
      ),
    );
  }
}
