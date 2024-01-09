import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DatabaseKeys {
  final String idKey = 'id';
  final String priceKey = 'price';
  final String litersKey = 'liters';
  final String dateKey = 'date';
  final String locationKey = 'location';
  final String euroPerLiterKey = 'euroPerLiter';
}

class CardData extends DatabaseKeys {
  final int id;
  final double price;
  final double liters;
  final DateTime date;
  final String location;
  final double euroPerLiter;

  CardData({
    required this.id,
    required this.price,
    required this.liters,
    required this.date,
    required this.location,
    required this.euroPerLiter,
  });

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      priceKey: price,
      litersKey: liters,
      dateKey: date.toUtc().toIso8601String(), // Convert DateTime to string
      locationKey: location,
      euroPerLiterKey: euroPerLiter,
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      id: map['id'],
      price: map['price'],
      liters: map['liters'],
      date: DateTime.parse(map['date']), // Convert string to DateTime
      location: map['location'],
      euroPerLiter: map['euroPerLiter'],
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
