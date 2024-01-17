import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/utils/key_parameters.dart';

const int CAR_ID = 0;

class DatabaseHelper with DatabaseCardKeys, DatabaseUserKeys, DatabaseCarKeys {
  static Database? _database;
  static const String dbName = 'card_database.db';

  static int carID = CAR_ID;

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
          $userUsernameKey TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE $carTableName (
          $carIdKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $carUserIdKey INTEGER,
          $carBrandKey TEXT,
          $carModelKey REAL,
          $carYearKey INT,
          $carConsumptionKey REAL,
          $carTotalKmKey REAL
        )
        ''');
        await db.execute('''
        CREATE TABLE $cardTableName(
          $idKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $relatedCarIdKey INTEGER,
          $priceKey REAL,
          $litersKey REAL,
          $dateKey TEXT,
          $locationKey TEXT,
          $euroPerLiterKey REAL,
          $kmKey REAL
        )
        ''');
        await db.execute(
            '''INSERT INTO $userTableName($userNameKey, $userSurnameKey, $userUsernameKey) VALUES("Name", "Surname", "Username");''');
        await db.execute(
            '''INSERT INTO $carTableName($carUserIdKey, $carBrandKey, $carModelKey, $carYearKey, $carConsumptionKey, $carTotalKmKey) VALUES(0,"Fiat", "Panda", 0000, 0.0, 0.0);''');
        await db.execute(
            '''INSERT INTO $carTableName($carUserIdKey, $carBrandKey, $carModelKey, $carYearKey, $carConsumptionKey, $carTotalKmKey) VALUES(1,"Lancia", "Delta", 0000, 0.0, 0.0);''');
      },
    );
  }

  Future<int> insertCard(CardData card) async {
    print("insert card");
    final db = await database;
    return db.insert(cardTableName, card.toMap());
  }

  Future<List<CardData>> getCardsByCar(selectedCarId) async {
    print("get db data");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      cardTableName,
      where: '$relatedCarIdKey = ?',
      whereArgs: [selectedCarId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<List<CardData>> getYearCard() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT $idKey, $relatedCarIdKey, SUM($priceKey) AS $priceKey, SUM($litersKey) AS $litersKey, $dateKey, $locationKey, $euroPerLiterKey FROM $cardTableName WHERE $relatedCarIdKey = $carID GROUP BY STRFTIME('%mm', $dateKey);");
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<List<CardData>> getMonthCard() async {
    final db = await database;
    int month = DateTime.now().month;
    String formattedMonth = '';
    if (month <= 9) {
      formattedMonth = '0$month';
    } else {
      formattedMonth = month.toString();
    }
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $cardTableName WHERE $relatedCarIdKey = $carID AND STRFTIME('%m', $dateKey) = '$formattedMonth';");
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<int> deleteCard(CardData card) async {
    print("remove db data");
    final db = await database;
    return db.delete(
      cardTableName,
      where: 'id = ?',
      whereArgs: [card.id], // Assuming you have an 'id' field in your CardData
    );
  }

  Future<UserData> getUserData(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      userTableName,
      orderBy: 'username DESC LIMIT 1', // TODO make it user related
    );
    return UserData.fromMap(maps.first);
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
      {carTotalKmKey: totalKm},
      where: '$carIdKey = ?',
      whereArgs: [carId],
    );
  }
}
