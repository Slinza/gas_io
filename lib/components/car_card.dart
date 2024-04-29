import 'package:flutter/material.dart';
import 'package:gas_io/screens/car_settings_details.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gas_io/utils/key_parameters.dart';
import 'package:gas_io/components/fuel_type.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/design/styles.dart';

CarData defaultCarData = CarData(
    id: 0,
    userId: 0,
    brand: 'Brand',
    model: 'Model',
    year: 2000,
    initialKm: 0,
    fuelType: 'disel');

class CarData with DatabaseCarKeys {
  int id;
  int userId;
  String brand;
  String model;
  int year;
  double initialKm;
  String fuelType;

  CarData({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.year,
    required this.initialKm,
    required this.fuelType,
  });

  Map<String, dynamic> toMap() {
    return {
      carIdKey: id,
      carUserIdKey: userId,
      carBrandKey: brand,
      carModelKey: model,
      carYearKey: year,
      carInitialKmKey: initialKm,
      carFuelType: fuelType,
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
        fuelType: map['fuelType']);
  }
}

class CarCard extends StatelessWidget {
  const CarCard({Key? key, required this.carData}) : super(key: key);
  final CarData carData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsCarSettingsScreen(carData)),
          ) //.then((value) {
          //   if (value != null && value) {
          //     fetchUserData();
          //   }
          // });
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      carData.brand,
                      style: cardStyle,
                    ),
                    Text(
                      carData.model,
                      style: cardStyle,
                    ),
                    Text(
                      carData.fuelType,
                      style: cardStyle,
                    ),
                    // Text(
                    //   "l/km = ${carData.fuelConsumption}",
                    //   style: GoogleFonts.abel(
                    //       textStyle: const TextStyle(fontSize: 18)),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
