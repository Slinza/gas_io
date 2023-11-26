import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: const Color(0xFF46BD84),
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_gas_station),
          label: 'Refuel',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            // color: Color.fromRGBO(255, 255, 255, 1)
          ),
          label: 'User',
        ),
      ],
    );
  }
}
