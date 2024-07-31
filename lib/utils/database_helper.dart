import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/utils/key_parameters.dart';
import 'package:gas_io/components/gas_station_schema.dart';

class DatabaseHelper
    with
        DatabaseRefuelKeys,
        DatabaseUserKeys,
        DatabaseCarKeys,
        DatabaseGasStationKeys {
  static Database? _database;
  static const String dbName = 'refuels_database.db';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      return initDatabase();
    }
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $userTableName (
          $userIdKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $userNameKey TEXT,
          $userSurnameKey TEXT,
          $userUsernameKey TEXT,
          $userEmailKey TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE $carTableName (
          $carIdKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $carUserIdKey INTEGER,
          $carBrandKey TEXT,
          $carModelKey REAL,
          $carYearKey INT,
          $carInitialKmKey REAL,
          $carFuelType TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE $refuelTableName(
          $idKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $relatedCarIdKey INTEGER,
          $priceKey REAL,
          $litersKey REAL,
          $dateKey TEXT,
          $gasStatIdKey INTEGER,
          $euroPerLiterKey REAL,
          $kmKey REAL,
          $isCompleteRefuelKey INTEGER
        )
        ''');
        await db.execute('''
        CREATE TABLE $gasStationTableName(
          $gasStationIdKey TEXT PRIMARY KEY,
          $gasStationLatitudeKey REAL,
          $gasStationLongitudeKey REAL,
          $gasStationNameKey TEXT,
          $gasStationFormattedAddressKey TEXT,
          $gasStationShortFormattedAddressKey TEXT
        )
        ''');
      },
    );
  }

  Future<int> insertRefuel(RefuelData refuel) async {
    if (kDebugMode) {
      print("insert refuel");
    }
    final db = await database;
    return db.insert(refuelTableName, refuel.toMap());
  }

  Future<int> insertGasStation(GasStationData gasStation) async {
    if (kDebugMode) {
      print("insert gas station");
    }
    final db = await database;
    final existingGasStations = await db.query(
      gasStationTableName,
      where: '$gasStationIdKey = ?',
      whereArgs: [gasStation.id],
    );

    if (existingGasStations.isNotEmpty) {
      // Gas station with the same ID already exists, return 0
      return 0;
    } else {
      // Gas station doesn't exist, insert it
      return db.insert(gasStationTableName, gasStation.toMap());
    }
  }

  Future<GasStationData?> getGasStationById(String gasStationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      gasStationTableName,
      where: '$gasStationIdKey = ?',
      whereArgs: [gasStationId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return GasStationData.fromMap(maps.first);
    } else {
      return null; // Gas station with the specified ID not found
    }
  }

  Future<List<RefuelData>> getRefuelsByCar(selectedCarId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      refuelTableName,
      where: '$relatedCarIdKey = ?',
      whereArgs: [selectedCarId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return RefuelData.fromMap(maps[i]);
    });
  }

  // TODO: check that will fetch only the previous year, discuss if necessary
  Future<List<RefuelData>> getYearRefuels(selectedCarId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT $idKey, $relatedCarIdKey, ROUND(SUM($priceKey), 2) AS $priceKey, ROUND(SUM($litersKey), 2) AS $litersKey, $dateKey, $gasStatIdKey, $euroPerLiterKey, $kmKey FROM $refuelTableName WHERE $relatedCarIdKey = $selectedCarId GROUP BY STRFTIME('%mm', $dateKey);");
    return List.generate(maps.length, (i) {
      return RefuelData.fromMap(maps[i]);
    });
  }

  Future<List<RefuelData>> geSixMonthsRefuels(selectedCarId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT $idKey, $relatedCarIdKey, ROUND(SUM($priceKey), 2) AS $priceKey, ROUND(SUM($litersKey), 2) AS $litersKey, $dateKey, $gasStatIdKey, $euroPerLiterKey, $kmKey FROM $refuelTableName WHERE $relatedCarIdKey = $selectedCarId AND $dateKey BETWEEN datetime('now', '-6 months') AND datetime('now', '+1 day') GROUP BY STRFTIME('%mm', $dateKey);");

    if (maps.isEmpty) {
      // Handle the case when no data is retrieved from the database
      List<RefuelData> missingData = [];
      // Loop over the last 6 months and create default RefuelData objects
      for (int i = 0; i < 6; i++) {
        missingData.add(
          generateEmptyRefuelData(
            selectedCarId,
            DateTime.now().subtract(
              Duration(days: i * 30),
            ),
          ),
        );
      }
      return missingData;
    } else {
      // Add placeholder for missing months
      List<int> presentMonths = List.generate(
        maps.length,
        (i) {
          return DateTime.parse(maps[i][dateKey]).month;
        },
      );
      List<int> expectedMonths = List.generate(
        6,
        (i) {
          return DateTime.now()
              .subtract(
                Duration(days: i * 30),
              )
              .month;
        },
      );
      List<RefuelData> listOfRefuelsData = [];
      for (final (index, m) in expectedMonths.indexed) {
        if (presentMonths.contains(m)) {
          listOfRefuelsData.add(
            RefuelData.fromMap(
              maps[presentMonths.indexOf(m)],
            ),
          );
        } else {
          listOfRefuelsData.add(
            generateEmptyRefuelData(
              selectedCarId,
              DateTime.now().subtract(
                Duration(days: index * 30),
              ),
            ),
          );
        }
      }
      return listOfRefuelsData;
    }
  }

  Future<List<RefuelData>> getMonthRefuels(selectedCarId) async {
    final db = await database;
    int month = DateTime.now().month;
    String formattedMonth = '';
    if (month <= 9) {
      formattedMonth = '0$month';
    } else {
      formattedMonth = month.toString();
    }
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $refuelTableName WHERE $relatedCarIdKey = $selectedCarId AND STRFTIME('%m', $dateKey) = '$formattedMonth' ORDER BY $dateKey ASC;");
    return List.generate(maps.length, (i) {
      return RefuelData.fromMap(maps[i]);
    });
  }

  Future<int> deleteRefuels(RefuelData refuel) async {
    final db = await database;
    return db.delete(
      refuelTableName,
      where: '$idKey = ?',
      whereArgs: [
        refuel.id
      ], // Assuming you have an 'id' field in your RefuelData
    );
  }

  Future<int> deleteAllRefuelsByCarId(int carId) async {
    final db = await database;
    return db.delete(
      refuelTableName,
      where: '$relatedCarIdKey = ?',
      whereArgs: [carId], // Assuming you have an 'id' field in your RefuelData
    );
  }

  Future<List<UserData>> getUserData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      userTableName,
      orderBy: 'username DESC',
    );
    return List.generate(maps.length, (i) {
      return UserData.fromMap(maps[i]);
    });
  }

  Future<Map<int, String>> getCarsMap() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      carTableName,
      columns: [carIdKey, carBrandKey, carModelKey],
    );

    return {
      for (var car in maps)
        car[carIdKey]: '${car[carBrandKey]} ${car[carModelKey]}'
    };
  }

  // New method to update total kilometers traveled by a car
  Future<void> updateTotalKm(int carId, double totalKm) async {
    final db = await database;
    await db.update(
      carTableName,
      {carInitialKmKey: totalKm},
      where: '$carIdKey = ?',
      whereArgs: [carId],
    );
  }

  Future<Map<String, RefuelData?>> getPreviousAndNextRefuel(
      int selectedCarId, DateTime currentDate,
      {int? excludeRefuelId}) async {
    final db = await database;

    // Get the previous refuel
    final List<Map<String, dynamic>> previousRefuelMap = await db.rawQuery(
      "SELECT * FROM $refuelTableName WHERE $relatedCarIdKey = $selectedCarId AND $dateKey < ?"
      "${excludeRefuelId != null ? ' AND $idKey != $excludeRefuelId' : ''}"
      " ORDER BY $dateKey DESC LIMIT 1;",
      [currentDate.toIso8601String()],
    );
    RefuelData? previousRefuel;
    if (previousRefuelMap.isNotEmpty) {
      previousRefuel = RefuelData.fromMap(previousRefuelMap.first);
    }

    // Get the next refuel
    final List<Map<String, dynamic>> nextRefuelMap = await db.rawQuery(
      "SELECT * FROM $refuelTableName WHERE $relatedCarIdKey = $selectedCarId AND $dateKey > ?"
      "${excludeRefuelId != null ? ' AND $idKey != $excludeRefuelId' : ''}"
      " ORDER BY $dateKey ASC LIMIT 1;",
      [currentDate.toIso8601String()],
    );
    RefuelData? nextRefuel;
    if (nextRefuelMap.isNotEmpty) {
      nextRefuel = RefuelData.fromMap(nextRefuelMap.first);
    }

    return {'previousRefuel': previousRefuel, 'nextRefuel': nextRefuel};
  }

  Future<void> updateRefuel(RefuelData newRefuel) async {
    final db = await database;

    await db.update(
      refuelTableName,
      newRefuel.toMap(),
      where: '$idKey = ?',
      whereArgs: [newRefuel.id],
    );
  }

  // USER SECTION

  Future<void> updateUsername(int userId, String newUsername) async {
    final db = await database;
    await db.update(
      userTableName,
      {userUsernameKey: newUsername},
      where: '$userIdKey = ?',
      whereArgs: [userId],
    );
  }

  Future<int> insertUser(UserData user) async {
    Database db = await database;
    return await db.insert(userTableName, user.toMap());
  }

  Future<UserData?> getUser() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(userTableName, limit: 1);
    if (maps.isNotEmpty) {
      return UserData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserData user) async {
    Database db = await database;
    return await db.update(userTableName, user.toMap(),
        where: '$userIdKey = ?', whereArgs: [user.id]);
  }

  // CAR SECTION

  Future<int> insertCar(CarData car) async {
    Database db = await database;
    return await db.insert(carTableName, car.toMap());
  }

  Future<Map<String, dynamic>> getCarDetailsById(int carId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      carTableName,
      where: '$carIdKey = ?',
      whereArgs: [carId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      throw Exception("Car with ID $carId not found");
    }
  }

  Future<List<CarData>> getCarsByUser(int userId) async {
    print("get db data");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      carTableName,
      where: '$carUserIdKey = ?',
      whereArgs: [userId],
      orderBy: 'id ASC',
    );
    return List.generate(maps.length, (i) {
      return CarData.fromMap(maps[i]);
    });
  }

  Future<void> updateCar(CarData newCar) async {
    final db = await database;

    await db.update(
      carTableName,
      newCar.toMap(),
      where: '$idKey = ?',
      whereArgs: [newCar.id],
    );
  }

  Future<int> deleteCar(CarData car) async {
    final db = await database;
    deleteAllRefuelsByCarId(car.id);
    return db.delete(
      carTableName,
      where: 'id = ?',
      whereArgs: [car.id], // Assuming you have an 'id' field in your CarData
    );
  }
}
