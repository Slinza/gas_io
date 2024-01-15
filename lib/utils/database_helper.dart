import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/utils/key_parameters.dart';

class DatabaseHelper with DatabaseCardKeys, DatabaseUserKeys, DatabaseCarKeys {
  static Database? _database;
  static const String dbName = 'card_database.db';

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
            $carUserIdKey REAL,
            $carBrandKey TEXT,
            $carModelKey REAL,
            $carYearKey REAL,
            $carConsumptionKey REAL
          )
          ''');
        await db.execute('''
          CREATE TABLE $cardTableName(
            $idKey INTEGER PRIMARY KEY AUTOINCREMENT,
            $relatedCarIdKey REAL,
            $priceKey REAL,
            $litersKey REAL,
            $dateKey TEXT,
            $locationKey TEXT,
            $euroPerLiterKey REAL
          )
          ''');
        await db.execute(
            '''INSERT INTO $userTableName($userNameKey, $userSurnameKey, $userUsernameKey) VALUES("Name", "Surname", "Username");''');
        await db.execute(
            '''INSERT INTO $carTableName($carUserIdKey, $carBrandKey, $carModelKey, $carYearKey, $carConsumptionKey) VALUES(0,"Brand", "Model",0000,0);''');
      },
    );
  }

  Future<int> insertCard(CardData card) async {
    print("insert card");
    final db = await database;
    return db.insert(cardTableName, card.toMap());
  }

  Future<List<CardData>> getCards() async {
    print("get db data");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      cardTableName,
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<List<CardData>> getYearCard() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT $idKey, SUM($priceKey) AS $priceKey, SUM($litersKey) AS $litersKey, $dateKey, $locationKey, $euroPerLiterKey FROM $cardTableName GROUP BY STRFTIME('%mm', $dateKey);");
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<List<CardData>> getMonthCard() async {
    final db = await database;
    int month = DateTime.now().month;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $cardTableName WHERE STRFTIME('%m', $dateKey) = '$month';");
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

  Future<List<UserData>> getUserData(int Id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      userTableName,
      orderBy: 'username DESC',
    );
    return List.generate(maps.length, (i) {
      return UserData.fromMap(maps[i]);
    });
  }
}
