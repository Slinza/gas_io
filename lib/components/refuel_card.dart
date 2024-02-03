import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gas_io/utils/key_parameters.dart';

class CardData with DatabaseCardKeys {
  final int id;
  final int carId;
  final double price;
  final double liters;
  final DateTime date;
  final String location;
  final double euroPerLiter;
  final double km;

  CardData({
    required this.id,
    required this.carId,
    required this.price,
    required this.liters,
    required this.date,
    required this.location,
    required this.euroPerLiter,
    required this.km,
  });

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      relatedCarIdKey: carId,
      priceKey: price,
      litersKey: liters,
      dateKey: date.toUtc().toIso8601String(), // Convert DateTime to string
      locationKey: location,
      euroPerLiterKey: euroPerLiter,
      kmKey: km,
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      id: map['id'],
      carId: map["carId"],
      price: map['price'],
      liters: map['liters'],
      date: DateTime.parse(map['date']).toLocal(), // Convert string to DateTime
      location: map['location'],
      euroPerLiter: map['euroPerLiter'],
      km: map['km']
    );
  }
}

class RefuelCard extends StatelessWidget {
  const RefuelCard({Key? key, required this.refuelData}) : super(key: key);
  final CardData refuelData;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat(
                      'dd-MM-yyyy - HH:mm',
                    ).format(refuelData.date),
                    style: GoogleFonts.abel(
                        textStyle: const TextStyle(fontSize: 18)),
                  ),
                  Row(children: [
                    const Icon(
                      Icons.location_pin,
                      size: 15,
                    ),
                    Text(
                      refuelData.location,
                      style: GoogleFonts.abel(
                          textStyle: const TextStyle(fontSize: 18)),
                    )
                  ]),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 5),
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              refuelData.price.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontFamily: 'SevenSegment',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Text(
                              refuelData.liters.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'SevenSegment',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "€",
                              style: GoogleFonts.abel(
                                  textStyle: const TextStyle(fontSize: 30)),
                            ),
                            Text(
                              "L",
                              style: GoogleFonts.abel(
                                  textStyle: const TextStyle(fontSize: 21)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 5),
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              refuelData.euroPerLiter.toStringAsFixed(3),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontFamily: 'SevenSegment',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "€/L",
                          style: GoogleFonts.abel(
                              textStyle: const TextStyle(fontSize: 25)),
                        ),
                      )
                    ],
                  )
                ])
          ],
        ),
      ),
    );
  }
}
