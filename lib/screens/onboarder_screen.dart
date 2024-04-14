import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gas_io/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: OnboardingScreens(),
//     );
//   }
// }

class OnboardingScreens extends StatefulWidget {
  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  void nextAction(int currentPage) {
    if (currentPage < 2) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
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
              WelcomePage(),
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
                // TODO remove button from the first page
                _currentPage > 0
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: Text('Back'),
                      )
                    : Container(
                        width: 80,
                      ),
                Text('Page ${_currentPage + 1} of 3'),
                ElevatedButton(
                  onPressed: () {
                    nextAction(_currentPage);
                  },
                  child: _currentPage + 1 == 3 ? Text("Start") : Text('Next'),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Text('Welcome Page'),
      ),
    );
  }
}

class NameSurnamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Text('How should we call you?'),
      ),
    );
  }
}

class CarDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: Text('Which car do we want to refuel?'),
      ),
    );
  }
}
