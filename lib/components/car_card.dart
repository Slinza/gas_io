import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gas_io/utils/key_parameters.dart';

class CarData with DatabaseCarKeys {
  int id;
  int userId;
  String brand;
  String model;
  int year;
  double initialKm;

  CarData({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.year,
    required this.initialKm,
  });

  Map<String, dynamic> toMap() {
    return {
      carIdKey: id,
      carUserIdKey: userId,
      carBrandKey: brand,
      carModelKey: model,
      carYearKey: year,
      carInitialKmKey: initialKm,
    };
  }

  factory CarData.fromMap(Map<String, dynamic> map) {
    return CarData(
      id: map['id'],
      userId: map["userId"],
      brand: map['brand'],
      model: map['model'],
      year: map['year'],
      initialKm: map['initialKm'],
    );
  }
}

class CarCard extends StatelessWidget {
  const CarCard({Key? key, required this.carData}) : super(key: key);
  final CarData carData;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    carData.brand,
                    style: GoogleFonts.abel(
                        textStyle: const TextStyle(fontSize: 18)),
                  ),
                  Text(
                    carData.model,
                    style: GoogleFonts.abel(
                        textStyle: const TextStyle(fontSize: 18)),
                  ),
                  Text(
                    "year = ${carData.year}",
                    style: GoogleFonts.abel(
                        textStyle: const TextStyle(fontSize: 18)),
                  ),
                  // Text(
                  //   "l/km = ${carData.fuelConsumption}",
                  //   style: GoogleFonts.abel(
                  //       textStyle: const TextStyle(fontSize: 18)),
                  // ),
                ]),
          ],
        ),
      ),
    );
  }
}
