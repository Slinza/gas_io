import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gas_io/screens/onboarder_screen.dart';
import 'package:gas_io/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showOnboarding = false;

  @override
  void initState() {
    super.initState();
    checkShowOnboarding();
  }

  void checkShowOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool openedBefore = prefs.getBool('openedBefore') ?? false;

    if (!openedBefore) {
      setState(() {
        showOnboarding = true;
      });
      prefs.setBool('openedBefore', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showOnboarding) {
      return const OnboardingScreens();
    } else {
      return const OnboardingScreens(); //HomeScreen();
    }
  }
}
