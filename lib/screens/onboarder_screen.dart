import 'package:flutter/material.dart';

import 'package:gas_io/screens/home_screen.dart';
import 'package:gas_io/screens/onboarder_user.dart';
import 'package:gas_io/screens/onboarder_car.dart';
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
  bool _isUserDataValid = false;
  bool _isCarDataValid = false;

  void nextAction(int currentPage) {
    if (currentPage == 1 && !_isUserDataValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid user data and save.')),
      );
      return;
    }

    if (currentPage == 2 && !_isCarDataValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid car data and save.')),
      );
      return;
    }

    if (currentPage < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void onUserDataValid(bool isValid) {
    setState(() {
      _isUserDataValid = isValid;
    });
  }

  void onCarDataValid(bool isValid) {
    setState(() {
      _isCarDataValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              const WelcomePage(),
              NameSurnamePage(onUserDataValid: onUserDataValid),
              CarDataPage(onCarDataValid: onCarDataValid),
            ],
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remove the "Back" button to prevent going back to previous pages
                _currentPage > 0
                    ? const SizedBox(width: 80)
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
