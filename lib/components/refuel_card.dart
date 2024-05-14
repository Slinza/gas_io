import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gas_io/utils/key_parameters.dart';
import 'package:gas_io/design/themes.dart';
import 'package:gas_io/utils/database_helper.dart';
import 'package:gas_io/components/gas_station_schema.dart';

CardData generateEmptyCardData(int carId, DateTime mockedDateTime) {
  return CardData(
    id: -1,
    carId: carId,
    price: 0.0,
    liters: 0.0,
    date: mockedDateTime,
    gasStationId: "Unknown", // TODO check placeholder
    euroPerLiter: 0.0,
    km: 0,
    isCompleteRefuel: false,
  );
}

class CardData with DatabaseCardKeys {
  final int id;
  final int carId;
  final double price;
  final double liters;
  final DateTime date;
  final String gasStationId;
  final double euroPerLiter;
  final double km;
  final bool isCompleteRefuel;

  CardData(
      {required this.id,
      required this.carId,
      required this.price,
      required this.liters,
      required this.date,
      required this.gasStationId,
      required this.euroPerLiter,
      required this.km,
      required this.isCompleteRefuel});

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      relatedCarIdKey: carId,
      priceKey: price,
      litersKey: liters,
      dateKey: date.toUtc().toIso8601String(), // Convert DateTime to string
      gasStatIdKey: gasStationId,
      euroPerLiterKey: euroPerLiter,
      kmKey: km,
      isCompleteRefuelKey: isCompleteRefuel ? 1 : 0, // Convert bool to integer
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      id: map['id'],
      carId: map["carId"],
      price: map['price'],
      liters: map['liters'],
      date: DateTime.parse(map['date']).toLocal(), // Convert string to DateTime
      gasStationId: map['gasStationId'],
      euroPerLiter: map['euroPerLiter'],
      km: map['km'],
      isCompleteRefuel: map['isCompleteRefuel'] == 1, // Convert integer to bool
    );
  }
}

class RefuelCard extends StatelessWidget {
  const RefuelCard({Key? key, required this.refuelData}) : super(key: key);
  final CardData refuelData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GasStationData?>(
      future: DatabaseHelper().getGasStationById(refuelData.gasStationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Placeholder while loading
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final gasStationData = snapshot.data;
        return gasStationData != null
            ? Card(
                margin: EdgeInsets.zero,
                color: cardColor,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    gasStationData.name,
                                    style: GoogleFonts.abel(
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    gasStationData.shortFormattedAddress,
                                    style: GoogleFonts.abel(
                                      textStyle: const TextStyle(fontSize: 9),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.location_pin,
                                size: 26,
                              ),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "€",
                                        style: GoogleFonts.abel(
                                            textStyle:
                                                const TextStyle(fontSize: 30)),
                                      ),
                                      Text(
                                        "L",
                                        style: GoogleFonts.abel(
                                            textStyle:
                                                const TextStyle(fontSize: 21)),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        refuelData.euroPerLiter
                                            .toStringAsFixed(3),
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
                                        textStyle:
                                            const TextStyle(fontSize: 25)),
                                  ),
                                )
                              ],
                            )
                          ])
                    ],
                  ),
                ),
              )
            : Container(); // Empty container if gas station data is null
      },
    );
  }
}
