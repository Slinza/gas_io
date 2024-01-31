import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedCarId;
  final Map<int, String> cars;
  final Function(int) onCarChanged;

  const MyAppBar({
    Key? key,
    required this.selectedCarId,
    required this.cars,
    required this.onCarChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Gas.io',
            style: TextStyle(
              color: Color(0xFF46BD84),
              fontSize: 50,
              fontFamily: 'Red Rose',
              fontWeight: FontWeight.w700,
              height: 0.01,
              letterSpacing: 0.30,
            ),
          ),
          const SizedBox(width: 16), // Adjust spacing between title and dropdown
          // Car Selector Dropdown
          DropdownButton<int>(
            value: selectedCarId,
            onChanged: (int? newValue) {
              if (newValue != null) {
                onCarChanged(newValue);
              }
            },
            items: cars.keys.toList().map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(cars[value] ?? ''),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
