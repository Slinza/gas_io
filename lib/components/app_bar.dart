import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Gas.io',
        // textAlign: TextAlign.left,
        style: TextStyle(
          color: Color(0xFF46BD84),
          fontSize: 50,
          fontFamily: 'Red Rose',
          fontWeight: FontWeight.w700,
          height: 0.01,
          letterSpacing: 0.30,
        ),
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.add),
      //     onPressed: () {
      //       // Handle the "+" button press
      //       print('Add button pressed');
      //     },
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
